#!/bin/bash

export BAKE_UBUNTU_VERSION="22.04"
echo Building container 
docker buildx bake dockerd
container_image=ubuntu-dockerd-${BAKE_UBUNTU_VERSION}
echo Starting conainter - $container_image
container_id=$(docker run -d --rm \
      --privileged \
      --cgroupns host \
      --tmpfs /run,/tmp \
      $container_image)
echo Container ID: $container_id
docker exec -it $container_id bash
docker container stop $container_id
