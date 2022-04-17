#!/usr/bin/env bash

set -ev

export BUILD_VERSION="0.0.2-SNAPSHOT"
export BUILD_DATE=`date +%Y-%m-%dT%T%z`

SCRIPT_DIR=$(dirname "$0")

if [[ -z "$GROUP" ]] ; then
    echo "Cannot find GROUP env var"
    exit 1
fi

if [[ -z "$COMMIT" ]] ; then
    echo "Cannot find COMMIT env var"
    exit 1
fi

if [[ "$(uname)" == "Darwin" ]]; then
    DOCKER_CMD=docker
else
    DOCKER_CMD="sudo docker"
fi
CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
echo $CODE_DIR

REPO=${GROUP}/$(basename user);

$DOCKER_CMD build \
  --build-arg BUILD_VERSION=$BUILD_VERSION \
  --build-arg BUILD_DATE=$BUILD_DATE \
  --build-arg COMMIT=$COMMIT \
  -t ${REPO}:${COMMIT} \
  -f $CODE_DIR/docker/user/Dockerfile-release $CODE_DIR;

$DOCKER_CMD build \
  -t ${REPO}-db:${COMMIT} \
  -f $CODE_DIR/docker/user-db/Dockerfile $CODE_DIR/docker/user-db;

