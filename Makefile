DOCKER_USER := ogarcia
DOCKER_ORGANIZATION := ogarcia
DOCKER_IMAGE := polaris

docker-image:
	docker build -t $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) .

docker-image-test: docker-image
	docker run -t -d -p 5050:5050 --name=polaris $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE)
	sleep 4
	curl -v 127.0.0.1:5050
	docker stop polaris
	docker rm polaris

ci-test: docker-image-test

.PHONY: docker-image docker-image-test ci-test
# vim:ft=make
