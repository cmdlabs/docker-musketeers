COMPOSE_BUILD_MUSKETEERS = docker-compose build musketeers
COMPOSE_RUN_MUSKETEERS = docker-compose run --rm musketeers
DOCKER_RUN_ENVVARS = docker run --rm -v $(PWD):/opt/app -w /opt/app flemay/envvars
COMPOSE_RUN_ENVVARS = docker-compose run --rm envvars

all: envfileExample build test clean

travis: envfile build test triggerDockerHubBuilds clean

envfile:
	$(DOCKER_RUN_ENVVARS) envfile --overwrite

envfileExample:
	$(DOCKER_RUN_ENVVARS) envfile --example --overwrite

pull:
	docker pull $(IMAGE_NAME)

build:
	$(COMPOSE_BUILD_MUSKETEERS)

test:
	$(COMPOSE_RUN_ENVVARS) validate
	$(COMPOSE_RUN_MUSKETEERS) bash -c "make --version \
		&& zip --version \
		&& git --version \
		&& curl --version \
		&& which openssl \
		&& docker --version \
		&& docker-compose --version \
		&& bash --version"

shell:
	$(COMPOSE_RUN_MUSKETEERS)

clean:
	docker-compose down --remove-orphans
	$(DOCKER_RUN_ENVVARS) envfile --rm

triggerDockerHubBuilds:
	$(COMPOSE_RUN_ENVVARS) ensure
	$(COMPOSE_RUN_MUSKETEERS) make _triggerDockerHubBuildForTagLatest

_triggerDockerHubBuildForTagLatest:
	@set -e; if [ "$(TRAVIS_BRANCH)" = "master" ]; then \
		curl -H "Content-Type: application/json" --data '{"docker_tag": "latest"}' -X POST $(DOCKERHUB_TRIGGER_URL); \
		echo " TRIGGERED Docker build for branch master"; \
	else \
		echo " SKIPPED Docker build for branch master"; \
	fi;
