#!/bin/sh

OPTIND=1
CONTAINER_NAME=clion_remote_env
IMAGE_NAME=clion/remote-cpp-env:latest
PORT=2222

while getopts "h?n:i:p:" opt; do
  case "$opt" in
  h|\?)
    echo "Run the docker image for remote cpp development over ssh."
    echo "Make sure you build the image first with 'sh build.sh'"
    echo "Once running, connect with remote@localhost:PORT (default PORT=2222)"
    echo "and password 'password'. Stop the container with 'sh stop.sh'"
    echo
    echo "-n CONTAINER_NAME gives a name for the running container."
    echo "To stop the container you will need to use 'sh stop.sh CONTAINER_NAME'"
    echo "Defaults to ${CONTAINER_NAME}"
    echo
    echo "-i IMAGE_NAME specifies the docker image name to run."
    echo "Defaults to ${IMAGE_NAME}."
    echo
    echo "-p PORT specifies a port number to map for ssh access."
    echo "Defaults to ${IMAGE_NAME}."
    exit 0
    ;;
  n) CONTAINER_NAME=$OPTARG
    echo "Naming the container ${CONTAINER_NAME}."
    ;;
  i) IMAGE_NAME=$OPTARG
    echo "Using image ${IMAGE_NAME}."
    ;;
  p) PORT=$OPTARG
    echo "Using port ${PORT}"
  esac
done

sh ./stop.sh "$CONTAINER_NAME"

echo "Spinning up container ${CONTAINER_NAME} from image ${IMAGE_NAME}..."
docker run -d --cap-add sys_ptrace -p127.0.0.1:"$PORT":22 --name "$CONTAINER_NAME" "$IMAGE_NAME"

# TODO: Enable this with a flag, it requires sudo but is not always needed
#echo "Clearing any cached SSH keys on port ${PORT}"
#sudo ssh-keygen -f "$HOME/.ssh/known_hosts" -R 127.0.0.1:"$PORT"

echo "Done"