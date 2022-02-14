#!/bin/sh

usage="${0} gzdoom | eternity-engine [commit-ish]"

case "${1}" in
  gzdoom)
    doom=gzdoom
    mkdir -p build/gzdoom/patches
    ;;
  eternity*)
    doom=eternity-engine
    mkdir -p build/eternity-engine/patches
    ;;
  *)
  echo "${usage}"
  exit 1
esac

docker run \
  --rm \
  --tty \
  --interactive \
  --env TZ="$(date +%Z)" \
  --name "${doom}" \
  --workdir /build/ \
  --user="$(id --user)":"$(id --group)" \
  --volume "$(pwd)/build:/build" \
  doom "$@"
