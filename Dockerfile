FROM ubuntu:18.04

ENV VERSION=1.0.0 \
    SERVICE=pyzor-server \
    OS=ubuntu \
    DEBIAN_FRONTEND=noninteractive

LABEL maintainer="docker-dario@neomediatech.it" \
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/$SERVICE \
      org.label-schema.maintainer=Neomediatech

RUN apt-get update && apt-get -y dist-upgrade && apt-get --no-install-recommends install -y python-pip redis-tools && \
    apt-get -y autoremove --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install setuptools && \
    pip install wheel && \
    pip install pyzor redis

COPY bin/* /
COPY conf/* /root/.pyzor/
RUN chmod +x /entrypoint.sh /tini

EXPOSE 24441

HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=20 CMD pyzor ping

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/tini","--","pyzord","--homedir=/root/.pyzor/"]
