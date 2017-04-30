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

To use this in a local context (ie local-attach), you'll need to install
cinderlcient and the cinder-brick extension for cinderclient on your
systems.  The current release version in pypi doesn't include noauth
support, so you'll need to install from source, but that's not hard:

```shell
sudo pip install pytz
sudo pip install git+https://github.com/openstack/python-cinderclient
sudo pip install git+https://github.com/openstack/python-brick-cinderclient-ext
```

Now, you can source the included cinder.rc file to use the client to
communicate with your containerized cinder deployment, with noauth!!

Remember, to perform local-attach/local-detach of volumes you'll need to use
sudo.  To preserve your env variables don't forget to use `sudo -E cinder xxxxx`

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

## Access using the cinderclient container

You can use your own cinderclient and openrc, or use the provided cinderclient
container.  You'll need to make sure and specify to use the same network
that was used by compose.

```shell
docker run -it -e OS_AUTH_TYPE=noauth \
  -e CINDERCLIENT_BYPASS_URL=http://cinder-api:8776/v3 \
  -e OS_PROJECT_ID=foo \
  -e OS_VOLUME_API_VERSION=3.27 \
  --network blockbox_default cinderclient list
```

# Or without docker-compose
That's ok, you can always just run the commands yourself using docker run:
```shell

# We set passwords and db creation in the docker-entrypoint-initdb.d script
docker run -d -p 3306:3306 \
  -v ~/BlockBox/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d \
  --name dbhost \
  --hostname dbhost \
  -e MYSQL_ROOT_PASSWORD=password \
  mariadb

# Make sure the environment vars match the startup script for your dbhost
docker run -d -p 5000:5000 \
  -p 35357:35357 \
  --link dbhost \
  --name keystone \
  --hostname keystone \
  -e OS_PASSWORD=password \
  -e DEMO_PASSWORD=password \
  -e DB_HOST=dbhost \
  -e DB_PASSWORD=password \
  keystone

docker run -d -p 5672:5672 --name rabbit --hostname rabbit rabbitmq

docker run -d -p 8776:8776 \
  --link dbhost \
  --link rabbit \
  --name cinder-api \
  --hostname cinder-api \
  -v ~/BlockBox/etc-cinder:/etc/cinder \
  -v ~/BlockBox/init-scripts:/init-scripts
  cinder_debian sh /init-scripts/cinder-api.sh

docker run -d --name cinder-scheduler \
  --hostname cinder-scheduler \
  --link dbhost \
  --link rabbit \
  -v ~/BlockBox/etc-cinder:/etc/cinder \
  cinder_debian cinder-scheduler

docker run -d --name cinder-volume \
  --hostname cinder-volume \
  --link dbhost \
  --link rabbit \
  -v ~/BlockBox/etc-cinder:/etc/cinder \
  cinder-debian cinder-volume
```
## TODO
Some people like Keystone, we have a working version here that's
custom to Cinder.  Still needs a few things like adding endpoints etc
but should be pretty straightforward to setup.

*NOTE*
We're departing from our norm here of using src packages and just using
Ubuntu 17.04 with packages for now.  Keystone is a bit more involved to
setup, particularly from source so we're starting with the path of least
resistance.  Maybe you'd like to work on this and submit the first PR for
the project :)
