#!/bin/bash

REDIS_SERVER=${REDIS_SERVER:-redis}
LOGS_DIR=${LOGS_DIR:-/data/logs}
if [ ! -d $LOGS_DIR ]; then
    mkdir -p $LOGS_DIR
fi
for FILE in log.log usage.log; do
    touch $LOGS_DIR/$FILE
    chmod 666 $LOGS_DIR/$FILE
done

# Variable WAITFOR set as a space separated series of comma separated values
# i.e.: "my_clamav:clamav:3310
# 3rd parameter (port) can be omitted for default ports
check_service() {
  until eval $1 ; do
    sleep 1
    echo -n "..."
  done
  echo -n "OK"
}
if [ -n "$WAITFOR" ]; then
  for CHECK in $WAITFOR; do
    IFS=':' read -a SERVICE <<< "$CHECK"
    # while array: ${SERVICE[*]}
    NAME="${SERVICE[0]}"
    SRV="${SERVICE[1]}"
    PORT="${SERVICE[2]}"
    if [ -z "$NAME" -o -z "$SRV" ]; then
      continue
    fi
    echo -n "Checking for service $SRV on $NAME..."
    case "$SRV" in
      "clamav")
        PORT=${PORT:-3310}
        check_service 'echo PING | nc -w 5 $NAME $PORT 2>/dev/null'
        ;;
      "rspamd")
        check_service 'ping -c1 $NAME 1>/dev/null 2>/dev/null'
        ;;
      "redis")
        PORT=${PORT:-6379}
        check_service 'timeout 2s redis-cli -h $NAME -p $PORT PING'
        ;;
      *)
        check_service 'ping -c1 $NAME 1>/dev/null 2>/dev/null'
        ;;
    esac
    echo " "
  done
fi

sed -i "s/REDIS_SERVER/$REDIS_SERVER/g" /root/.pyzor/config

exec tail -F $LOGS_DIR/* &
exec "$@"
