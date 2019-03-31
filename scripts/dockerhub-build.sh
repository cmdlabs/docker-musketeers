#!/usr/bin/env sh
set -e
set -u

curl -H "Content-Type: application/json" --data '{"docker_tag": "latest"}' -X POST ${DOCKERHUB_TRIGGER_URL}
echo " TRIGGERED Docker build for branch master"
