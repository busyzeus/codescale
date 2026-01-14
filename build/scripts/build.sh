#!/bin/env bash

TARGET="${1:-ubuntu-all}"

NO_CACHE=false
if [ "$2" == "no-cache" ]; then
  NO_CACHE=true
fi

pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null
echo docker buildx bake --set ${TARGET}.no-cache=$NO_CACHE --progress=plain $TARGET 
docker buildx bake --set ${TARGET}.no-cache=$NO_CACHE --progress=plain $TARGET 
popd > /dev/null

docker image ls -a --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}\t{{.ID}}" | grep -E "REPOSITORY|$TARGET"
