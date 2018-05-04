#!/bin/sh

mkdir -p build

docker run \
  --rm \
  --tty \
  --interactive \
  --name gzdoom \
  --workdir /gzdoom \
  --user=$(id --user):$(id --group) \
  --volume $(pwd)/build:/gzdoom/build \
  gzdoom
