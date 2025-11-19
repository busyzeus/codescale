#!/bin/env bash

TARGET="${1:-ubuntu-all}"

pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null
#docker buildx bake --no-cache $TARGET 
docker buildx bake --set ubuntu-all.no-cache=true $TARGET 
#docker buildx bake $TARGET 
popd > /dev/null

docker image ls | grep $TARGET
