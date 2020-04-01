#!/bin/bash

ARCHIVE=/tmp/src.tar.gz
SRC_DIR=/usr/local/src

# # Start dockerd in background
nohup dockerd > /var/log/docker.log 2>&1 &

if [ -f "${ARCHIVE}" ]; then
  tar xzf ${ARCHIVE} -C ${SRC_DIR}
fi

# if [ -f /etc/gitlab-runner/certs/lpwgitp01.npd.com.cert ]; then
#   cp /etc/gitlab-runner/certs/lpwgitp01.npd.com.cert /usr/local/share/ca-certificates/ && update-ca-certificates
# fi

exec "$@"
