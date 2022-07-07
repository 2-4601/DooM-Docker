FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y \
      cmake \
      g++ \
      git \
      libbz2-dev \
      libfluidsynth-dev \
      libgl1-mesa-dev \
      libglew-dev \
      libgme-dev \
      libgtk-3-dev \
      libjpeg-dev \
      libmpg123-dev \
      libopenal-dev \
      libsdl2-dev \
      libsdl2-mixer-dev \
      libsdl2-net-dev \
      libsndfile1-dev \
      libvpx-dev \
      make \
      nasm \
      tar \
      timidity \
      zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Initial settings
RUN mkdir /build_scripts
ADD build.sh build_gzdoom.sh build_eternity-engine.sh /build_scripts/

ENTRYPOINT ["/build_scripts/build.sh"]
