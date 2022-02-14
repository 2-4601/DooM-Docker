A Dockerfile and build script to compile the [GZDoom](https://github.com/coelckers/gzdoom) and [Eternity Engine](https://github.com/team-eternity/eternity) DooM source ports for Ubuntu Linux.

# Installation

## TL;DR

- Only do this once:
```
$ cd image_build_context/
$ docker build --file Dockerfile --tag doom .
```

- Then after that you can compile _GZDoom_ with:
```
$ ./run_container_and_build_doom.sh gzdoom
```

- Or _Eternity Engine_ with:
```
$ ./run_container_and_build_doom.sh eternity-engine
```

- Binaries can be found in the `build/{gzdoom,eternity-engine}/binaries` directory

*******************************************************************************

## Longer version

At the very first time you need to create an image which is described in
the `Dockerfile`. You can do this by going to the `image_build_context/` directory:
```
$ cd image_build_context/
```

And then running:
```
$ docker build --file Dockerfile --tag doom .
```

This could take several minutes. But you only need to do it once.
(Please ignore the bash scripts in the same folder. They are just helper scripts
which are copied automatically into the image by the `Dockerfile`.)

When you have the image ready you can reuse it over and over again to create containers which will build _GZDoom_ or _Eternity Engine_ for you.

Now to compile _GZDoom_'s latest stable version with the Docker container run the `run_container_and_build_doom.sh` script with the `gzdoom` argument:
```
$ ./run_container_and_build_doom.sh gzdoom
```

To build the latest stable version of the _Eternity Engine_ pass the `eternity-engine` argument:
```
$ ./run_container_and_build_doom.sh eternity-engine
```

You can also give a `commit-ish` as an extra argument. E.g. to build the latest commit of _GZDoom_ run the script like this:
```
$ ./run_container_and_build_doom.sh gzdoom HEAD
```

Binaries can be found in the `build/{gzdoom,eternity-engine}/binaries` directory
