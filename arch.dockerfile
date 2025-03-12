# :: Util
  FROM 11notes/util AS util

# :: Header
  FROM 11notes/alpine:stable

  # :: arguments
    ARG TARGETARCH
    ARG APP_IMAGE
    ARG APP_NAME
    ARG APP_VERSION
    ARG APP_ROOT

  # :: environment
    ENV APP_IMAGE=${APP_IMAGE}
    ENV APP_NAME=${APP_NAME}
    ENV APP_VERSION=${APP_VERSION}
    ENV APP_ROOT=${APP_ROOT}

  # :: multi-stage
    COPY --from=util /usr/local/bin/ /usr/local/bin

# :: Run
  USER root
  RUN eleven printenv;

  # :: install application
    RUN set -ex; \
      apk --update --no-cache add \
        dcron=~${APP_VERSION}; \
      apk --update --no-cache --virtual .build add \
        libcap-setcap; \
      mkdir -p ${APP_ROOT}/etc; \
      rm -rf /etc/cron.d/*; \
      rm -rf /etc/crontabs; \
      ln -sf ${APP_ROOT}/etc /etc/crontabs;

  # :: copy filesystem changes and set correct permissions
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin; \
      chown -R 1000:1000 \
        /usr/sbin/crond \
        /var/spool/cron/crontabs \
        ${APP_ROOT};

  # :: set special caps
    RUN set -ex; \
      setcap cap_setgid=ep /usr/sbin/crond; \
      apk del --no-network .build;

# :: Monitor
  HEALTHCHECK --interval=5s --timeout=2s CMD netstat -an | grep -q 1688 || exit 1

# :: Start
  USER docker