# Docker CLion Remote C++ Development Environment

Setting up build and debugging environments is a pain. CLion is a great
IDE and works out of the box with default c++ and cmake toolchains, but
depending on the project requirements and your operating environment it can
quickly become a hassle.

This repository gives all the necessary tools to build and run a
dedicated Docker container which CLion can access over ssh as a
remote development environment, allowing you to build, run and debug your code independently of your host environment. 

## Usage

Prerequisites: Docker, CLion 2020

Step 1: Build the docker image with `sh build.sh` (this will take a while the first time around).

Step 2: Spin up the container with `sh run.sh`.

Step 3: If not already done, [create a remote toolchain in CLion](https://www.jetbrains.com/help/clion/remote-projects-support.html#remote-toolchain)
using the following credentials:
 - host `127.0.0.1`
 - port `2222`
 - username `remote`
 - password `password`
 
Step 4: If not already done, [create a CMake profile that uses the remote toolchain](https://www.jetbrains.com/help/clion/remote-projects-support.html#CMakeProfile).

Step 5: [Resync the header search paths](https://www.jetbrains.com/help/clion/remote-projects-support.html#resync).
Repeat this step any time you change the compiler or project dependencies.
Optionally you can enable automatic synchronization 

Step 6: [Select the remote CMake profile](https://www.jetbrains.com/help/clion/remote-projects-support.html#WorkWithRemote)
to build, run and debug entirely with the remote toolchain.

## Options

By default, the development environment uses cmake version 3.17.5,
which is the latest version supported by CLion. You can specify
a different version (between 2.8.x and 3.17.x) using `sh build.sh -v CMAKE_VER`.
This will then tag the image name with `:CMAKE_VER`.

You can change the mapped port (default 2222) of the container with `sh run.sh -p PORT`.
 
You can change the name of the generated image or running container with respective flags
in the build and run scripts. See `sh build -h` and `sh run.sh -h` for more info.

Sometimes there will be an issue cached SSH host keys. You can clear them with 
`sudo ssh-keygen -f "$HOME/.ssh/known_hosts" -R 127.0.0.1:2222`, 
or replace 2222 with your custom port.

## Extension

The base image provided simply configures the essential tools for C++ development
and debugging and sets up the corresponding ssh profile. It is encouraged to create
new Dockerfiles that inherit from this image when adding more build dependencies
(for example, `yaml-cpp` or `cppzmq`). You can then take your development
environments anywhere you go.

Additionally, the container is mapped to localhost by default. Use a different
address in the run script and cmake profile to have your build environment always
available on the network (on some server or even just a raspberry pi). 

## Further reading:
https://www.jetbrains.com/help/clion/clion-toolchains-in-docker.html

https://www.jetbrains.com/help/clion/remote-projects-support.html
