#!/bin/bash

container_image=codescale-ubuntu-all:24.04
echo Starting conainter - $container_image
container_id=$(docker run -d --rm \
      --privileged \
      --cgroupns host \
      --tmpfs /run,/tmp \
      $container_image)
echo Container ID: $container_id
docker logs -f $container_id &
docker exec -it $container_id bash
docker container stop $container_id
