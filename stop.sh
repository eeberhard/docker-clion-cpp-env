#!/bin/sh

NAME=clion_remote_env

if [ -n "$1" ]
then
  NAME=$1
fi

echo "Stopping and removing any container with name ${NAME}..."
docker container stop "$NAME" > /dev/null 2>&1
docker rm --force "$NAME" > /dev/null 2>&1
