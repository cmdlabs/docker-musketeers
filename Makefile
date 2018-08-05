COMPOSE_BUILD_MUSKETEERS = docker-compose build musketeers
COMPOSE_RUN_MUSKETEERS = docker-compose run --rm musketeers
DOCKER_RUN_ENVVARS = docker run --rm -v $(PWD):/opt/app -w /opt/app flemay/envvars
COMPOSE_RUN_ENVVARS = docker-compose run --rm envvars

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
	$(COMPOSE_BUILD_MUSKETEERS)
.PHONY: build

test:
	$(COMPOSE_RUN_ENVVARS) validate
	$(COMPOSE_RUN_MUSKETEERS) make --version
	$(COMPOSE_RUN_MUSKETEERS) zip --version
	$(COMPOSE_RUN_MUSKETEERS) git --version
	$(COMPOSE_RUN_MUSKETEERS) curl --version
	$(COMPOSE_RUN_MUSKETEERS) which openssl
	$(COMPOSE_RUN_MUSKETEERS) docker --version
	$(COMPOSE_RUN_MUSKETEERS) docker-compose --version
	$(COMPOSE_RUN_MUSKETEERS) bash --version
.PHONY: test

shell:
	$(COMPOSE_RUN_MUSKETEERS)
.PHONY: shell

clean:
	docker-compose down --remove-orphans
	$(DOCKER_RUN_ENVVARS) envfile --rm
.PHONY: clean

#######################
# DOCKER HUB TRIGGERS #
#######################

triggerDockerHubBuilds:
	$(COMPOSE_RUN_ENVVARS) ensure
	$(COMPOSE_RUN_MUSKETEERS) make _triggerDockerHubBuildForTagLatest
.PHONY: triggerDockerHubBuilds

_triggerDockerHubBuildForTagLatest:
	@curl -H "Content-Type: application/json" --data '{"docker_tag": "latest"}' -X POST $(DOCKERHUB_TRIGGER_URL)
.PHONY: _triggerDockerHubBuildForTagLatest