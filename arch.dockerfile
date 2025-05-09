# ╔═════════════════════════════════════════════════════╗
# ║                       SETUP                         ║
# ╚═════════════════════════════════════════════════════╝
  # :: GLOBAL
  ARG APP_UID=1000 \
      APP_GID=1000

  # :: FOREIGN IMAGES
  FROM 11notes/util AS util

# ╔═════════════════════════════════════════════════════╗
# ║                       BUILD                         ║
# ╚═════════════════════════════════════════════════════╝

  FROM alpine AS build
  COPY --from=util /usr/local/bin /usr/local/bin
  USER root

  ARG APP_VERSION \
      APP_ROOT

  ENV BUILD_ROOT=/dcron \
      BUILD_BIN=/dcron/crond \
      CC=clang

  RUN set -ex; \
    apk --update --no-cache add \
      build-base \
      upx \
      clang \
      make \
      cmake \
      g++ \
      git;

  RUN set -ex; \
    git clone https://github.com/ptchinster/dcron -b v${APP_VERSION}; \
    sed -i 's/VERSION = .\+/VERSION = '${APP_VERSION}'/' ${BUILD_ROOT}/Makefile;
 
  RUN set -ex; \
    cd ${BUILD_ROOT}; \
    make -s -j $(nproc) \
      PREFIX=/usr \
      CRONTAB_GROUP=wheel \
      CRONTABS=${APP_ROOT}/etc \
      CRONSTAMPS=${APP_ROOT}/var \
      SCRONTABS=${APP_ROOT}/etc/cron.d \
      LDFLAGS="-static";

  RUN set -ex; \
    eleven checkStatic ${BUILD_BIN}; \
    eleven strip ${BUILD_BIN}; \
    mkdir -p /distroless/usr/local/bin; \
    cp ${BUILD_BIN} /distroless/usr/local/bin;

# ╔═════════════════════════════════════════════════════╗
# ║                       IMAGE                         ║
# ╚═════════════════════════════════════════════════════╝

  # :: HEADER
  FROM 11notes/alpine:stable

  # :: arguments
    ARG TARGETARCH \
        APP_IMAGE \
        APP_NAME \
        APP_VERSION \
        APP_ROOT \
        APP_UID \
        APP_GID

  # :: environment
    ENV APP_IMAGE=${APP_IMAGE} \
        APP_NAME=${APP_NAME} \
        APP_VERSION=${APP_VERSION} \
        APP_ROOT=${APP_ROOT}

  # :: multi-stage
    COPY --from=util /usr/local/bin /usr/local/bin
    COPY --from=build /distroless/usr/local/bin /usr/local/bin

# :: SETUP
  USER root
  RUN eleven printenv;

  # :: install application
    RUN set -ex; \
      apk --update --no-cache --virtual .setup add \
        libcap-setcap; \
      eleven mkdir ${APP_ROOT}/{etc,var}; \
      mkdir -p ${APP_ROOT}/etc/cron.d;

  # :: copy filesystem changes and set correct permissions
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin; \
      chown -R ${APP_UID}:${APP_GID} \
        /usr/local/bin/crond \
        ${APP_ROOT};

  # :: set special caps
    RUN set -ex; \
      setcap cap_setuid=ep /usr/local/bin/crond; \
      setcap cap_setgid=ep /usr/local/bin/crond; \
      apk del --no-network .setup;

# :: HEALTH
  HEALTHCHECK --interval=5s --timeout=2s --start-period=5s \
    CMD ps aux | grep -q "/usr/local/bin/crond"

# :: RUN
  USER ${APP_UID}:${APP_GID}