FROM ubuntu

# Install required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
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
      libsndfile1-dev \
      make \
      nasm \
      tar \
      timidity \
      zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Initial settings
RUN mkdir /build_scripts
ADD build_gzdoom.sh /build_scripts

CMD ["/build_scripts/build_gzdoom.sh"]
