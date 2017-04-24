CINDER_BRANCH ?= master # master, stable/ocata, refs/changes/67/418167/1
KEYSTONE_BRANCH ?= master # master, stable/ocata, refs/changes/67/418167/1
NAME_PREFIX ?= ""
PLATFORM ?= debian
TAG ?= latest

build: $(objects)

	docker build https://git.openstack.org/openstack/loci-cinder.git\#:$(PLATFORM) --tag cinder_$(PLATFORM):$(TAG) --build-arg PROJECT_REF=$(BRANCH)
	docker build https://git.openstack.org/openstack/loci-keystone.git\#:$(PLATFORM) --tag keystone_$(PLATFORM):$(TAG) --build-arg PROJECT_REF=$(BRANCH)
	docker build -t cinderclient ./cinderclient
	docker build -t osc ./osc
	docker build -t keystone ./keystone

default: build
