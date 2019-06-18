FROM ubuntu:18.04

ENV VERSION=1.0.0
ENV SERVICE=pyzor-server
ENV OS=ubuntu

ARG EXIM_DIR=/etc/exim4

LABEL maintainer="docker-dario@neomediatech.it" \
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/$SERVICE-$OS \
      org.label-schema.maintainer=Neomediatech

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Rome

RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get -y dist-upgrade && apt-get --no-install-recommends install -y python-pip tzdata redis-tools && \
    apt-get -y autoremove --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install setuptools && \
    pip install wheel && \
    pip install pyzor redis

COPY bin/tini /usr/local/sbin
COPY conf/* /root/.pyzor/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh /usr/local/sbin/tini

# only for testing
RUN apt-get update && \
    apt-get --no-install-recommends install -y redis && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 24441

HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=20 CMD pyzor ping

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tini","--","pyzord","--homedir=/root/.pyzor/"]
