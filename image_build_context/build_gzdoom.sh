#!/bin/bash

base_dir=/build/gzdoom
src_dir="${base_dir}"/src
build_os="$(uname --kernel-name | tr '[:upper:]' '[:lower:]')"
build_architecture="$(uname --machine)"
jobs=$(($(nproc) - 1)); [ "$jobs" -eq 0 ] && jobs=1

mkdir "${src_dir}"
cd "${src_dir}" || exit 1

echo "Fetching Zmusic sources"
if [ -d zmusic ]; then
  rm -rf zmusic
fi
git clone https://github.com/coelckers/ZMusic.git zmusic
cd zmusic || exit 1
mkdir -pv build
cd build || exit 1
zmusic_output_dir="${base_dir}"/zmusic
echo "Compiling Zmusic"
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${zmusic_output_dir}"
make -j$jobs
make install

cd "${src_dir}" || exit 1

echo "Fetching GZDooM sources"
if [ -d gzdoom ]; then
  rm -rf gzdoom
fi
git clone git://github.com/coelckers/gzdoom.git gzdoom
cd gzdoom || exit 1

if [ -n "${1}" ]; then
  release_tag="${1}"
  echo -n "Trying to check out tag: ${release_tag}..."
  if git checkout --force "${release_tag}"; then
    echo " success."
  else
    echo " fail."
    echo "Checking out the latest GZDooM release tag"
    release_tag="$(git tag -l 'g*' | grep -E '^g[0-9]+([.][0-9]+)*$' | sort -V | tail -n 1)" && \
    git checkout --force "${release_tag}"
  fi
else
  echo "Checking out the latest GZDooM release tag"
  release_tag="$(git tag -l 'g*' | grep -E '^g[0-9]+([.][0-9]+)*$' | sort -V | tail -n 1)" && \
  git checkout --force "${release_tag}"
fi

echo "Compiling GZDooM"
mkdir -vp build
cd build || exit 1
cmake .. -DCMAKE_BUILD_TYPE=Release -DZMUSIC_LIBRARIES="${zmusic_output_dir}"/lib/libzmusic.so -DZMUSIC_INCLUDE_DIR="${zmusic_output_dir}"/include/
make -j$jobs
echo "Compiling finished"

echo "Preparing binary release"
version=$(echo "${release_tag}" | sed 's/^g//;s/\./-/g')
binary_release_dir="${base_dir}"/binaries/gzdoom-bin-"${version}"-"${build_os}"-"${build_architecture}"
mkdir -vp "${binary_release_dir}"

echo "Installing binary release"
cp -rv "${src_dir}"/gzdoom/build/{gzdoom,*.pk3,soundfonts/,fm_banks/} \
       "${binary_release_dir}"
cp -v  "${zmusic_output_dir}"/lib/libzmusic.so* \
       "${binary_release_dir}"

echo "Copying SDL to binary release directory"
cp -v /usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0 "${binary_release_dir}"
cd "${binary_release_dir}" || exit 1

echo "Build process finished"
echo "You can find the binaries in ${binary_release_dir}"
