CINDER_BRANCH ?= master # stable/ocata, refs/changes/67/418167/1
KEYSTONE_BRANCH ?= master # stable/ocata, refs/changes/67/418167/1
NAME_PREFIX ?= ""
PLATFORM ?= debian

ifeq ($(CINDER_BRANCH),master)
    CINDER_TAG = latest
else
    CINDER_TAG = $(CINDER_BRANCH)
endif

ifeq ($(KEYSTONE_BRANCH),master)
    KEYSTONE_TAG = latest
else
    KEYSTONE_TAG = $(CINDER_BRANCH)
endif

build:

	docker build https://git.openstack.org/openstack/loci-cinder.git\#:$(PLATFORM) --tag cinder_$(PLATFORM):$(CINDER_TAG) --build-arg PROJECT_REF=$(BRANCH)
	docker build https://git.openstack.org/openstack/loci-keystone.git\#:$(PLATFORM) --tag keystone_$(PLATFORM):$(KEYSTONE_TAG) --build-arg PROJECT_REF=$(BRANCH)
	docker build -t cinderclient ./cinderclient
	docker build -t osc ./osc

default: build
