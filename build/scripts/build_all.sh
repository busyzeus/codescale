#!/bin/env bash

for TARGET in base systemd nix dockerd all; do
  BAKE_TARGET=ubuntu-$TARGET
  ./build.sh $BAKE_TARGET $1
  ./push.sh $BAKE_TARGET 
done

