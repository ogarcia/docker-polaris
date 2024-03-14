ALPINE_VERSION := 3.19.1
POLARIS_VERSION := 0.14.2
CONTAINER_ORGANIZATION := ogarcia
CONTAINER_IMAGE := polaris
CONTAINER_ARCHITECTURES := linux/amd64
TAGS := -t $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):master
TAGS += -t quay.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):master
TAGS += -t ghcr.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):master
ifdef CIRCLE_TAG
	TAGS := -t $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest
	TAGS += -t $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):${CIRCLE_TAG}
	TAGS += -t quay.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest
	TAGS += -t quay.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):${CIRCLE_TAG}
	TAGS += -t ghcr.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest
	TAGS += -t ghcr.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):${CIRCLE_TAG}
endif

all: container-build

check-dockerhub-env:
ifndef DOCKERHUB_USERNAME
	$(error DOCKERHUB_USERNAME is undefined)
endif
ifndef DOCKERHUB_PASSWORD
	$(error DOCKERHUB_PASSWORD is undefined)
endif

check-quay-env:
ifndef QUAY_USERNAME
	$(error QUAY_USERNAME is undefined)
endif
ifndef QUAY_PASSWORD
	$(error QUAY_PASSWORD is undefined)
endif

check-github-registry-env:
ifndef GITHUB_REGISTRY_USERNAME
	$(error GITHUB_REGISTRY_USERNAME is undefined)
endif
ifndef GITHUB_REGISTRY_PASSWORD
	$(error GITHUB_REGISTRY_PASSWORD is undefined)
endif

container-build:
	docker build -t $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --build-arg POLARIS_VERSION=$(POLARIS_VERSION) .

container-buildx:
	docker buildx build -t $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE) --platform $(CONTAINER_ARCHITECTURES) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --build-arg POLARIS_VERSION=$(POLARIS_VERSION) .

container-buildx-push: check-dockerhub-env check-quay-env check-github-registry-env
	echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
	echo "${QUAY_PASSWORD}" | docker login -u "${QUAY_USERNAME}" --password-stdin quay.io
	echo "${GITHUB_REGISTRY_PASSWORD}" | docker login -u "${GITHUB_REGISTRY_USERNAME}" --password-stdin ghcr.io
	docker buildx build $(TAGS) --platform $(CONTAINER_ARCHITECTURES) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --build-arg POLARIS_VERSION=$(POLARIS_VERSION) --push .

.PHONY: all check-dockerhub-env check-quay-env check-github-registry-env container-build container-buildx container-buildx-push
# vim:ft=make
