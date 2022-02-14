#!/bin/sh

case "${1}" in
  gzdoom)
    shift
    /build_scripts/build_gzdoom.sh "$@"
    ;;
  eternity*)
    shift
    /build_scripts/build_eternity-engine.sh "$@"
    ;;
  *)
    echo "Unsupported argument: ${1}"
    exit 1
esac
