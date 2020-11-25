#!/bin/sh

OPTIND=1
CMAKE_VER=""
IMAGE_NAME=clion/remote-cpp-env

while getopts "h?vn:" opt; do
  case "$opt" in
  h|\?)
    echo "Build the docker image for remote cpp development over ssh."
    echo
    echo "-v CMAKE_VER specifies a different cmake_version (CLion 2020 supports 2.8.x - 3.17.x)."
    echo "Defaults to cmake version 3.17.5."
    echo
    echo "-n IMAGE_NAME specifies a different docker image name."
    echo "Defaults to ${IMAGE_NAME}."
    exit 0
    ;;
  v) CMAKE_VER=$OPTARG
    echo "Using cmake version ${CMAKE_VER}."
    ;;
  n) IMAGE_NAME=$OPTARG
    echo "Using image name ${IMAGE_NAME}."
  esac
done

if [ -n "$CMAKE_VER" ]
then
  docker build -t "$IMAGE_NAME":"$1" --build-arg CMAKE_VER="$CMAKE_VER"
else
  docker build -t "$IMAGE_NAME" .
fi