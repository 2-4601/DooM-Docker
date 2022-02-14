A Dockerfile and build script to compile the latest version of GZDooM for Ubuntu Linux.

# Installation

## TL;DR

- Only do this once:
```
$ cd image_build_context/
$ docker build --file Dockerfile --tag gzdoom .
```
- Then after that you can compile GZDooM with:
```
$ ./run_container_and_build_gzdoom.sh
```

- Binaries can be found in the `build/gzdoom/binaries` directory

*******************************************************************************

## Longer version


At the very first time you need to create an image which is described in
the `Dockerfile`. You can do this by going to the `image_build_context/` directory:
```
$ cd image_build_context/
```

And then running:
```
$ docker build --file Dockerfile --tag gzdoom .
```

This will take several minutes. But you only need to do it once.
(Please ignore the bash script in the same folder. It is just a helper script
that is copied into the image automatically by the `Dockerfile`.)

When you have the image ready you can reuse it over and over again to create containers which will build GZDooM for you.

Now to compile GZDooM with the Docker container run the script:
```
$ ./run_container_and_build_gzdoom.sh
```

This takes a few minutes. Binaries will go to the `build/gzdoom/binaries` directory.

