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
Start by building the required images.  This repo includes a Makefile to
enable building of openstack/loci images of Cinder and Keystone.  The
Makefile includes variables to select between platform (debian, ubuntu or
centos) and also allows what branch of each project to biuld the image from.
This includes master, stable/xyz as well as patch versions.  Additional
variables are provided and can be passed to make using the `-e` option to
control things like naming and image tags.  See the Makefile for more info.

Simply running `make` with no arguments will result in Cinder and Keystone
images being built from the current master branch of the projects git repo.
The default is to use source, with no naming prefixes and to tag the images
as `latest` using Debian Jessie as the platform.

This will result in some base images that we'lluse:
  cinderclient
  openstackclient (osc)
  cinder (openstack/loci image)
  keystone (openstack/loci image)

The client images (cinderclient and osc) are set with their client executable
as their entryppoints.  To use, you need to provide the needed env variables
and the command you wish to issue.  For example to perform a `list` command
using the cinderclient container:

```shell
docker run -it -e OS_AUTH_TYPE=noauth \
  -e CINDERCLIENT_BYPASS_URL=http://cinder-api:8776/v3 \
  -e OS_PROJECT_ID=foo \
  -e OS_VOLUME_API_VERSION=3.27 \
  cinderclient list
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
