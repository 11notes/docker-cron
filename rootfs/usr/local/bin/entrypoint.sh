#!/bin/ash
  if [ -z "${1}" ]; then
    echo -e "${CRONTAB}" > ${APP_ROOT}/etc/docker
    set -- crond -c /etc/crontabs -f -P
    eleven log start
  fi

  exec "$@"