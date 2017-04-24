#!/bin/bash

/bin/sh -c "cinder-manage db sync" cinder
mkdir -p /var/log/cinder
touch /var/log/cinder/cinder-api.log
cinder-api -d --log-file /var/log/cinder/cinder-api.log
