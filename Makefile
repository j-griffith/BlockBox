CINDER_BRANCH ?= stable/ocata # master, stable/ocata, refs/changes/67/418167/1
NAME_PREFIX ?= ""
PLATFORM ?= debian
TAG ?= latest

build: $(objects)

	docker build https://git.openstack.org/openstack/loci-cinder.git\#:$(PLATFORM) --tag cinder:$(TAG) --build-arg PROJECT_REF="stable/ocata"
	docker build -t cinder-volume ./cinder-volume
	docker build -t osc ./osc

default: build
