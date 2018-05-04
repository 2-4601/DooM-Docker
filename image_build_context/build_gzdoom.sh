#!/bin/bash

BASE_DIR=$(pwd)
GIT_REPOSITORY_DIR=gzdoom
BUILD_OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
if [ "$(uname -m)" = "x86_64" ]; then
    BUILD_ARCHITECTURE='64'
else
    BUILD_ARCHITECTURE=''
fi

cd ${BASE_DIR}/${GIT_REPOSITORY_DIR}
echo "Pulling latest changes from the GZDooM source repository"
git pull
git fetch --tags

echo "Checking out the latest GZDooM release tag"
RELEASE_TAG="$(git tag -l 'g*' | grep -E '^g[0-9]+([.][0-9]+)*$' | sort -V | tail -n 1)" && \
git checkout --force ${RELEASE_TAG}

echo "Compiling GZDooM"
mkdir -vp ${BASE_DIR}/${GIT_REPOSITORY_DIR}/build
cd ${BASE_DIR}/${GIT_REPOSITORY_DIR}/build
make clean
cmake .. -DCMAKE_BUILD_TYPE=Release
make
echo "Compiling finished"

echo "Preparing binary release"
VERSION=$(echo ${RELEASE_TAG} | sed 's/^g//;s/\./-/g')
BINARY_RELEASE_DIR=output/gzdoom-bin-"${VERSION}"-"${BUILD_OS}""${BUILD_ARCHITECTURE}"
mkdir -vp ${BASE_DIR}/${BINARY_RELEASE_DIR}

echo "Installing binary release"
cp -v ${BASE_DIR}/${GIT_REPOSITORY_DIR}/build/{gzdoom,gzdoom.pk3,lights.pk3,brightmaps.pk3,output_sdl/liboutput_sdl.so} \
      ${BASE_DIR}/${BINARY_RELEASE_DIR}

echo "Copying SDL and sndio to binary release directory"
cp -v /usr/lib/x86_64-linux-gnu/libsndio.so.6.1 /usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0.4.0 ${BASE_DIR}/${BINARY_RELEASE_DIR}
cd ${BASE_DIR}/${BINARY_RELEASE_DIR}
ln -s libSDL2-2.0.so.0.4.0 libSDL2-2.0.so.0

echo "Fixing permissions for output volume directory"
chown -R ${USERID}.${USERID} ${BASE_DIR}/${BINARY_RELEASE_DIR}

echo "Build process finished"
echo "You can find the binaries in ${BINARY_RELEASE_DIR}"
