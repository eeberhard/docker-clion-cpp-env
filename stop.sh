#!/bin/sh

NAME=clion_remote_env

if [ -n "$1" ]
then
  NAME=$1
fi

echo "Trying to stop and remove container with name ${NAME}..."
docker container stop "$NAME"
docker rm --force "$NAME"