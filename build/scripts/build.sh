#!/bin/env bash

TARGET="${1:-ubuntu-all}"

pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null
echo $pwd
docker buildx bake $TARGET
popd > /dev/null

docker image ls | grep $TARGET
