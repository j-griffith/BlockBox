# BlockBox
Standalone Cinder Containerized using Docker Compose

## Cinder
Provides Block Storage as a service as part of the OpenStack Project.
This project deployes Cinder in containers using docker-compose and
also enabled the use of Cinder's noauth option which eliminates the
need for keystone.  One could also easily add keystone into the
compose file along with an init script to set up endpoints.

## LOCI (Lightweight Open Compute Initiative)
The master branch of BlockBox uses OpenStack Loci to build a base
Cinder image to use for each service.  We choose debian source builds
and the result is an extremely compact and efficient image.

We're currently using Cinder's noauth option but will be adding the
option to deploy a configured Keystone container as well.

## To build
First, make sure you have a loci base cinder image.  This repo includes
a simple bash script to pull and/or build the latest images needed
by the docker-compose file as well as tagging them as needed.
```shell
./bootstrap-images.sh
```

For more informaiton and options, check out the openstack/loci page on github:
https://github.com/openstack/loci


## To run
docker-compose up -d

Don't forget to modify the etc-cinder/cinder.conf file as needed for your
specific driver.  We'll be adding support for the LVM driver and LIO Tgts
shortly, but for now you won't have much luck without using an external
device (no worries, there are over 80 to choose from).

## cinderclient
The compose will also build a hacky cinderclient, so you can just do:
```shell
cinderclient cinder create --name foo 1
```

This is pretty messy right now but it's another thing on the list to be
improved upon soon.
