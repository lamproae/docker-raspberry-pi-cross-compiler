# Raspberry Pi Cross-Compiler in a Docker Container.

This image contains the [the Raspberry Pi cross-compilation toolchain](https://github.com/raspberrypi/tools), some common build tools, and a custom tool to install native Raspbian development packages.

This project is available as [sdt4docker/raspberry-pi-cross-compiler](https://registry.hub.docker.com/u/sdt4docker/raspberry-pi-cross-compiler/) on [Docker Hub](https://hub.docker.com/), and as [sdt/docker-raspberry-pi-cross-compiler](https://github.com/sdt/docker-raspberry-pi-cross-compiler) on [GitHub](https://github.com).

Please raise any issues on the [GitHub issue tracker](https://github.com/sdt/docker-raspberry-pi-cross-compiler/issues) as I don't get notified about Docker Hub comments.

## Features

* gcc-linaro-arm-linux-gnueabihf-raspbian toolchain from [raspberrypi/tools](https://github.com/raspberrypi/tools)
* easy installation of raspbian-native development packages
* commands in the container are run as the calling user, so that any created files have the expected ownership (ie. not root)
* make variables (`CC`, `LD` etc) are set to point to the appropriate tools in the container
* `ARCH`, `CROSS_COMPILE` and `HOST` environment variables are set in the container
* symlinks such as `rpxc-gcc` and `rpxc-objdump` are created in `/usr/local/bin`
* current directory is mounted as the container's workdir, `/build`
* works with boot2docker on OSX

## Installation

This image is not intended to be run manually. Instead, there is a helper script which comes bundled with the image.

To install the helper script, run the image with no arguments, and redirect the output to a file.

eg.
```
docker run sdt4docker/raspberry-pi-cross-compiler > ~/bin/rpxc
chmod +x ~/bin/rpxc
```

## Usage

`rpxc [command] [args...]`

Execute the given command-line inside the container.

If the command matches one of the rpxc built-in commands (see below), that will be executed locally, otherwise the command is executed inside the container.

---

`rpxc -- [command] [args...]`

To force a command to run inside the container (in case of a name clash with a built-in command), use `--` before the command.

### Built-in commands

`rpxc install-debian package packages...`

Install native (x64) packages into the rpxc image.

eg. `rpxc install-debian cmake`

`rpxc install-raspbian package packages...`

Install raspbian (armhf) development packages from the raspbian repositorires into the rpxc image. These will be available for use with your rpxc builds.

eg. `rpxc install-debian cmake`

`rpxc install-debian package packages...`

`rpxc update-image`

Fetch the latest version of the docker image.

If a new docker image is available, any extra packages installed with `install-debian` or `install-raspbian` _will be lost_.

---

`rpxc update-script`

Update the installed rpxc script with the one bundled in the image.

----

`rpxc update`

Update both the docker image, and the rpxc script.

## Configuration

The following command-line options and environment variables are used. In all cases, the command-line option overrides the environment variable.

### RPXC_CONFIG / --config &lt;path-to-config-file&gt;

This file is sourced if it exists.

Default: `~/.rpxc`

### RPXC_IMAGE / --image &lt;docker-image-name&gt;

The docker image to run.

Default: sdt4docker/raspberry-pi-cross-compiler

### RPXC_ARGS / --args &lt;docker-run-args&gt;

Extra arguments to pass to the `docker run` command.

## Custom Images

Using `rpxc install-debian` and `rpxc install-raspbian` are really only intended for getting a build environment together. Once you've figured out which debian and raspbian packages you need, it's better to create a custom downstream image that has all your tools and development packages built in.

### Create a Dockerfile

```Dockerfile
FROM sdt4docker/raspberry-pi-cross-compiler

# Install some native build-time tools
RUN install-debian scons

# Install raspbian development libraries
RUN install-raspbian libboost-dev-all
```

### Name your image with an RPXC_IMAGE variable and build the image

```sh
export RPXC_IMAGE=my-custom-rpxc-image
docker build -t $RPXC_IMAGE .
```

### With RPXC_IMAGE set, rpxc will automatically use your new image.

```sh
rpxc ./configure
rpxc make
```

## Examples

`rpxc make`

Build the Makefile in the current directory.

---

`rpxc rpxc-gcc -o hello-world hello-world.c`

Standard bintools are available by adding an `rpxc-` prefix.

---

`rpxc make`

Build the kernel from [raspberrypi/linux](https://github.com/raspberrypi/linux).
The CROSS_COMPILE and ARCH flags are automatically set.

---

`rpxc bash -c 'find . -name \*.o | sort > objects.txt'`

Note that commands are executed verbatim. If you require any shell processing for environment variable expansion or redirection, please use `bash -c 'command args...'`.

---

More examples can be found in the [examples directory](examples).
