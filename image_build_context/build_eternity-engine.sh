#!/bin/bash

set -euo pipefail

base_dir=/build/eternity-engine
src_dir="${base_dir}"/src
build_os="$(uname --kernel-name | tr '[:upper:]' '[:lower:]')"
build_architecture="$(uname --machine)"
binary_dir="${base_dir}"/binaries
jobs=$(($(nproc) - 1)); [ "$jobs" -eq 0 ] && jobs=1

echo "Cleaning up previous sources"
if [ -d "${src_dir}" ]; then
  rm -rf "${src_dir}"
fi

mkdir -pv "${src_dir}"

cd "${src_dir}" || exit 1

echo "Fetching Eternity Engine sources"
git clone https://github.com/Wohlstand/libADLMIDI.git
git clone https://github.com/team-eternity/eternity.git
cd eternity || exit 1
git submodule init
git config submodule.adlmidi.url ../libADLMIDI
git -c protocol.file.allow=always submodule update

if [ -n "${1+x}" ]; then
  release_tag="${1}"
  echo -n "Trying to check out tag: ${release_tag}..."
  if git checkout --force "${release_tag}"; then
    echo " success."
  else
    echo " fail."
    echo "Checking out the latest Eternity Engine release tag"
    release_tag="$(git tag -l | grep -E '^[0-9]\.[0-9]{2}\.[0-9]{2}$' | sort -V | tail -n 1)"
    git checkout --force "${release_tag}"
  fi
else
  echo "Checking out the latest Eternity Engine release tag"
  release_tag="$(git tag -l | grep -E '^[0-9]\.[0-9]{2}\.[0-9]{2}$' | sort -V | tail -n 1)"
  git checkout --force "${release_tag}"
fi

echo "Latest commit:"
git --no-pager log -1

for patch in "${base_dir}"/patches/*.patch; do
  if [ ! -f "${patch}" ]; then
    break;
  else
    echo "Applying patch: ${patch}"
    if ! patch --verbose -p1 -i "${patch}"; then
      echo "Applying patch ${patch} failed!"
      exit 1
    else
      patched="patched-"
    fi
  fi
done

echo "Compiling Eternity Engine"
# In-tree builds do not work
mkdir -pv ../build
cd ../build || exit 1
now=$(date +%F_%H.%M.%S)
binary_release_dir="${binary_dir}/eternity-engine-bin-${release_tag}-${patched-}${build_os}-${build_architecture}_${now}"
mkdir -pv "${binary_release_dir}"
cmake ../eternity -DCMAKE_INSTALL_PREFIX="${binary_release_dir}"
make -j$jobs
echo "Compiling finished"

echo "Installing binary release"
make install

echo "Build process finished"

cat << EOF > "${binary_release_dir}/eternity.sh"
#!/bin/sh
# A bug in v4.02.00 https://github.com/team-eternity/eternity/issues/495
#exec env LC_ALL="en_US.UTF-8" ./bin/eternity -base ./share/eternity/base "\$@"
exec ./bin/eternity -base ./share/eternity/base "\$@"
EOF
chmod u+x "${binary_release_dir}/eternity.sh"
echo "Start-up script generated."
