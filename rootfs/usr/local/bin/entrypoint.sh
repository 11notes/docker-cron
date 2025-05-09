#!/bin/ash
  if [ -z "${1}" ]; then
    echo -e "${CRONTAB}" > ${APP_ROOT}/etc/docker
    set -- /usr/local/bin/crond -c ${APP_ROOT}/etc -f -P
    eleven log start
  fi

  exec "$@"