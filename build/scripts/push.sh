#!/bin/env bash

UBUNTU_VER=${BAKE_UBUNTU_VERSION:-24.04}
IMAGE=${1:-ubuntu-all}
SOURCE=$IMAGE:$UBUNTU_VER

DOCKER_TARGET=lazyzeus/$IMAGE
TAG_DATE=$(date +%Y%m%d)
for TAG in $UBUNTU_VER ${UBUNTU_VER}-$TAG_DATE; do
  echo docker tag $SOURCE $DOCKER_TARGET:$TAG
  docker tag $SOURCE $DOCKER_TARGET:$TAG
  echo docker push $DOCKER_TARGET:$TAG
  docker push $DOCKER_TARGET:$TAG
done

