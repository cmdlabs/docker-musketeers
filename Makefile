VERSION = latest
IMAGE_NAME = flemay/musketeers:$(VERSION)
DOCKER_RUN_ENVVARS = docker run --rm -v $(PWD):/opt/app -w /opt/app flemay/envvars
COMPOSE_RUN_ENVVARS = docker-compose run --rm envvars
COMPOSE_RUN_MUSKETEERS = docker-compose run --rm musketeers
DOCKER_RUN_MUSKETEERS = docker run --rm $(IMAGE_NAME)

all: envfileExample build test clean
.PHONY: all

travis: envfile build test triggerDockerHubBuilds clean
.PHONY: travis

envfile:
	$(DOCKER_RUN_ENVVARS) envfile --overwrite
.PHONY: envfile

envfileExample:
	$(DOCKER_RUN_ENVVARS) envfile --example --overwrite
.PHONY: envfileExample

pull:
	docker pull $(IMAGE_NAME)
.PHONY: pull

build:
	docker build --no-cache -t $(IMAGE_NAME) .
.PHONY: build

test:
	$(COMPOSE_RUN_ENVVARS) validate
	$(DOCKER_RUN_MUSKETEERS) make --version
	$(DOCKER_RUN_MUSKETEERS) zip --version
	$(DOCKER_RUN_MUSKETEERS) git --version
	$(DOCKER_RUN_MUSKETEERS) curl --version
	$(DOCKER_RUN_MUSKETEERS) which openssl
	$(DOCKER_RUN_MUSKETEERS) docker --version
	$(DOCKER_RUN_MUSKETEERS) docker-compose --version
	$(DOCKER_RUN_MUSKETEERS) bash --version
.PHONY: test

shell:
	docker run --rm -it -v $(PWD):/opt/app $(IMAGE_NAME) sh -l
.PHONY: shell

remove:
	docker rmi -f $(IMAGE_NAME)
.PHONY: remove

clean:
	docker-compose down --remove-orphans
	$(DOCKER_RUN_ENVVARS) envfile --rm
.PHONY: clean

#######################
# DOCKER HUB TRIGGERS #
#######################

triggerDockerHubBuilds:
	$(COMPOSE_RUN_ENVVARS) ensure --tags travis
	$(COMPOSE_RUN_ENVVARS) make _ensureForDockerHub
	$(COMPOSE_RUN_MUSKETEERS) make _triggerDockerHubBuildForTagLatest
.PHONY: triggerDockerHubBuilds

_ensureForDockerHub:
	if [ "$(TRAVIS_BRANCH)" = "master" ]; then \
		ensure --tags dockerHub; \
		echo " DO ensure"; \
	else \
		echo " SKIPPED ensure"; \
	fi;
.PHONY: _ensureForDockerHub

_triggerDockerHubBuildForTagLatest:
	@if [ "$(TRAVIS_BRANCH)" = "master" ]; then \
		curl -H "Content-Type: application/json" --data '{"docker_tag": "latest"}' -X POST $(DOCKERHUB_TRIGGER_URL); \
		echo " TRIGGERED Docker build for branch master"; \
	else \
		echo " SKIPPED Docker build for branch master"; \
	fi;
.PHONY: _triggerDockerHubBuildForTagLatest