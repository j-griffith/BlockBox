#!/bin/bash
INIT_DB=${INIT_DB:-true}

if [ "$INIT_DB" = "true" ]; then
/bin/sh -c "cinder-manage db sync" cinder
fi
cinder-api -d
