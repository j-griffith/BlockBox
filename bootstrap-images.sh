#!/bin/bash

docker pull debian:jessie-slim
docker pull rabbitmq
docker pull mariadb
docker build https://git.openstack.org/openstack/loci-keystone.git\#:debian --tag loci_keystone:deb
docker build https://git.openstack.org/openstack/loci-cinder.git\#:debian --tag loci_cinder:deb
