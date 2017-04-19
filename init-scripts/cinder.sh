#!/bin/bash

/bin/sh -c "cinder-manage db sync" cinder
service apache2 restart
tail -f /var/log/apache2/cinder.log
