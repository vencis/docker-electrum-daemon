FROM python:3.8-alpine

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL maintainer="osintsev@gmail.com" \
  org.label-schema.vendor="Distirbuted Solutions, Inc." \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="Electrum wallet (RPC enabled)" \
  org.label-schema.description="Electrum wallet with JSON-RPC enabled (daemon mode)" \
  org.label-schema.version=$VERSION \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/osminogin/docker-electrum-daemon" \
  org.label-schema.usage="https://github.com/osminogin/docker-electrum-daemon#getting-started" \
  org.label-schema.license="MIT" \
  org.label-schema.url="https://electrum.org" \
  org.label-schema.docker.cmd='docker run -d --name electrum-daemon --publish 127.0.0.1:7000:7000 --volume /srv/electrum:/data osminogin/electrum-daemon' \
  org.label-schema.schema-version="1.0"

ENV ELECTRUM_VERSION $VERSION
ENV ELECTRUM_USER electrum
ENV ELECTRUM_PASSWORD electrumz    # XXX: CHANGE REQUIRED!
ENV ELECTRUM_HOME /home/$ELECTRUM_USER

RUN apk add --no-cache --virtual .build-deps build-base gcc musl-dev libffi-dev openssl-dev automake autoconf libtool git cargo python3-dev && \
  adduser -D $ELECTRUM_USER && \
  pip3 install --no-cache-dir cryptography && \
  mkdir -p /data ${ELECTRUM_HOME} && \
  ln -sf /data ${ELECTRUM_HOME}/.electrum && \
  wget -c https://download.electrum.org/${ELECTRUM_VERSION}/Electrum-${ELECTRUM_VERSION}.tar.gz -O - | tar -xz -C ${ELECTRUM_HOME} && \
  chown ${ELECTRUM_USER} ${ELECTRUM_HOME}/.electrum /data && \
  sh ${ELECTRUM_HOME}/Electrum-${ELECTRUM_VERSION}/contrib/make_libsecp256k1.sh && \
  pip3 install --no-cache-dir ${ELECTRUM_HOME}/Electrum-${ELECTRUM_VERSION} && \
  cp ${ELECTRUM_HOME}/Electrum-${ELECTRUM_VERSION}/electrum/libsecp256k1.so.0 /usr/local/lib/python3.8/site-packages/electrum/libsecp256k1.so.0 && \
  rm -rf ${ELECTRUM_HOME}/Electrum-${ELECTRUM_VERSION} && \
  apk del --no-cache .build-deps

USER $ELECTRUM_USER
WORKDIR $ELECTRUM_HOME
VOLUME /data
EXPOSE 7000

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["electrum"]
