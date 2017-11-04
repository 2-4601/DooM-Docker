FROM ubuntu

# Install required packages
RUN apt-get update && \
    apt-get install -y \
      build-essential \
      cmake \
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
      libsdl1.2-dev \
      libsdl2-dev \
      libsndfile1-dev \
      libwildmidi-dev \
      nasm \
      tar \
      timidity \
      zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Initial settings
WORKDIR /gzdoom_build

# Fetch GZDooM
RUN git clone git://github.com/coelckers/gzdoom.git

RUN mkdir -p output

ADD build_gzdoom.sh .

CMD ["./build_gzdoom.sh"]
