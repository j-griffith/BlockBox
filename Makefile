CINDER_BRANCH ?= stable/ocata # master, stable/ocata, refs/changes/67/418167/1
NAME_PREFIX ?= ""
PLATFORM ?= debian
TAG ?= latest

build: $(objects)
	cp ../../test-requirements.txt ./docker_files/
	docker build https://git.openstack.org/openstack/loci-cinder.git\#:$(PLATFORM) --tag cinder:$(TAG) --build-arg PROJECT_REF="stable/ocata"
	docker build -t cinder-volume -f ./docker_files/Dockerfile.cinder-volume .
	docker build -t cinder-devenv -f ./docker_files/Dockerfile.cinder-devenv .

default: build
