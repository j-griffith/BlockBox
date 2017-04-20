#!/bin/bash

docker pull debian:jessie-slim
docker pull rabbitmq
docker pull mariadb
docker build https://git.openstack.org/openstack/loci-keystone.git\#:debian --tag loci_keystone:deb
docker build https://git.openstack.org/openstack/loci-cinder.git\#:debian --tag loci_cinder:deb

cd osc && docker build -t osc .
cd ../cinderclient && docker build -t cinderclient .
