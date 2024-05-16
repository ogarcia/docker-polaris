include .env
CONTAINER_ORGANIZATION := connectical
CONTAINER_IMAGE := polaris

build:
	docker build -t $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --build-arg POLARIS_VERSION=$(POLARIS_VERSION) .

.PHONY: all build
# vim:ft=make
