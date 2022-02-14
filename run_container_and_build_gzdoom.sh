#!/bin/sh

mkdir -p build/gzdoom/patches

docker run \
  --rm \
  --tty \
  --interactive \
  --name gzdoom \
  --workdir /build/gzdoom \
  --user=$(id --user):$(id --group) \
  --volume $(pwd)/build:/build \
  gzdoom
