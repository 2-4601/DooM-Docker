#!/bin/bash

BASE_DIR=/gzdoom/build
SRC_DIR=src
BUILD_OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
if [ "$(uname -m)" = "x86_64" ]; then
    BUILD_ARCHITECTURE='64'
else
    BUILD_ARCHITECTURE=''
fi

cd ${BASE_DIR}

echo "Fetching GZDooM sources"
if [ -d "${SRC_DIR}" ]; then
  rm -rf ${SRC_DIR}
fi
git clone git://github.com/coelckers/gzdoom.git ${SRC_DIR}
cd ${SRC_DIR}

echo "Checking out the latest GZDooM release tag"
RELEASE_TAG="$(git tag -l 'g*' | grep -E '^g[0-9]+([.][0-9]+)*$' | sort -V | tail -n 1)" && \
git checkout --force ${RELEASE_TAG}

echo "Compiling GZDooM"
mkdir -vp build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
echo "Compiling finished"

echo "Preparing binary release"
mkdir -p ${BASE_DIR}/binaries
VERSION=$(echo ${RELEASE_TAG} | sed 's/^g//;s/\./-/g')
BINARY_RELEASE_DIR=binaries/gzdoom-bin-"${VERSION}"-"${BUILD_OS}""${BUILD_ARCHITECTURE}"
mkdir -vp ${BASE_DIR}/${BINARY_RELEASE_DIR}

echo "Installing binary release"
cp -v ${BASE_DIR}/${SRC_DIR}/build/{gzdoom,gzdoom.pk3,lights.pk3,brightmaps.pk3,output_sdl/liboutput_sdl.so} \
      ${BASE_DIR}/${BINARY_RELEASE_DIR}

echo "Copying SDL and sndio to binary release directory"
cp -v /usr/lib/x86_64-linux-gnu/{libsndio.so.6.1,libSDL2-2.0.so.0} ${BASE_DIR}/${BINARY_RELEASE_DIR}
cd ${BASE_DIR}/${BINARY_RELEASE_DIR}

echo "Build process finished"
echo "You can find the binaries in build/${BINARY_RELEASE_DIR}"
