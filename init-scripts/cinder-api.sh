#!/bin/bash
INIT_DB=${INIT_DB:-true}

if [ "$INIT_DB" = "true" ]; then
/bin/sh -c "cinder-manage db sync" cinder
fi

mkdir -p /var/log/cinder
touch /var/log/cinder/cinder-api.log
cinder-api -d --log-file /var/log/cinder/cinder-api.log
