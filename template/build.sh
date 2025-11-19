#!/bin/env bash

TARGET="${1:-ubuntu-all}"

set -e


pushd "$(dirname "${BASH_SOURCE[0]}")"
#pushd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null

export $(grep -v '^#' .env | xargs)
pushd ../build
docker buildx bake $TARGET
#docker buildx bake $TARGET
popd > /dev/null

popd > /dev/null


