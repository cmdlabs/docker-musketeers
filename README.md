[![Build Status][linkBadgeTravisBuildStatus]][linkTravisMusketeers]
[![Docker Build Status][linkBadgeDockerBuildStatus]][linkDockerHubMusketeers]
[![Docker Size][linkBadgeDockerSize]][linkMicroBadgerMusketeers]
[![Docker Downloads][linkBadgeDockerDownloads]][linkDockerHubMusketeers]
[![License](https://img.shields.io/dub/l/vibe-d.svg)](LICENSE)

# Docker - Musketeers

🐳 Lightweight image with essential tools for a [3 Musketeers][link3Musketeers] project. ⚔️

## Tools

- Docker: useful when doing Docker in Docker (DinD).
- Compose
- make
- zip
- curl
- git
- openssl
- bash
- envsubst

## Usage

```bash
# pull image
$ docker pull flemay/musketeers
# run image
$ docker run --rm flemay/musketeers docker --version
```

```bash
# Development

# generate .env file
$ make envfile
# build image
$ make build
# test image
$ make test
# go inside a musketeers container
$ make shell
```

## Example

The GitLab pipeline to build and test the Docker image [flemay/cookiecutter][link3MusketeersExamples] uses `flemay/musketeers` image.

## Versioning

This image will always be built with the tag `latest` so tools will always be up to date. This may cause issues if any tool has a breaking change.

## Automated build process

In a nutshell, any change to master triggers a [Travis build][linkTravisMusketeers] and if the tests passed it triggers a [Docker Hub build][linkDockerHubMusketeers]. The automatic build on Docker Hub has been disabled ensuring the build process to go only through Travis.

A cron task in Travis triggers a build every month making the image to be as fresh as possible automatically.


[linkDockerHubMusketeers]: https://hub.docker.com/r/flemay/musketeers
[linkTravisMusketeers]: https://travis-ci.org/flemay/3musketeers
[link3Musketeers]: https://3musketeers.io
[link3MusketeersExamples]: https://3musketeers.io/examples/
[linkMicroBadgerMusketeers]: https://microbadger.com/images/flemay/musketeers

[linkBadgeTravisBuildStatus]: https://travis-ci.org/flemay/docker-musketeers.svg?branch=master
[linkBadgeDockerSize]: https://images.microbadger.com/badges/image/flemay/musketeers.svg
[linkBadgeDockerDownloads]:https://img.shields.io/docker/pulls/flemay/musketeers.svg
[linkBadgeDockerBuildStatus]: https://img.shields.io/docker/build/flemay/musketeers.svg