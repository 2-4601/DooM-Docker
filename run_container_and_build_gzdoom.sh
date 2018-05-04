#!/bin/sh

mkdir -p output

docker run \
  --rm \
  --tty \
  --interactive \
  --name gzdoom \
  --env USERID=$(id -u) \
  --workdir /gzdoom_build \
  --volume $(pwd)/output:/gzdoom_build/output \
  gzdoom
