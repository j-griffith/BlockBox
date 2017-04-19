#!/bin/bash

/bin/sh -c "cinder-manage db sync" cinder
service apache2 restart
cinder-api
