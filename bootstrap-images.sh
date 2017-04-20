#!/bin/bash

docker pull debian:jessie-slim
docker pull rabbitmq
docker pull mariadb

docker build https://git.openstack.org/openstack/loci-keystone.git\#:debian \
--tag keystone:ocata \
--build-arg PROJECT_REF=stable/ocata

docker build https://git.openstack.org/openstack/loci-cinder.git\#:debian \
--tag cinder:ocata \
--build-arg PROJECT_REF=stable/ocata

cd osc && docker build -t osc .
cd ../cinderclient && docker build -t cinderclient .
