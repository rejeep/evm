#!/bin/bash

VERSION="26.0.91"
IMAGE="evm-travis-builder:latest"
KEEP_CONTAINER=0

function usage {
    printf "$0 [OPTIONS]\n\n"
    printf "Build Emacs for execution in Travis CI.\n\n"
    printf "Options:\n"
    printf "  -h       Show help\n"
    printf "  -k       Keep Docker container after build (default: false)\n"
    printf "  -v VER   Build this emacs version (default: $VERSION)\n"
    exit 0
}

while getopts "hkv:" opt; do
    case "$opt" in
        h) usage
           ;;
        k) KEEP_CONTAINER=1
           ;;
        v) VERSION=$OPTARG
           ;;
    esac
done
CONTAINER="build-emacs-$VERSION-travis"

### Docker commands need to run in project's root directory

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/..

### Create the build image. If the image already exists and the
### contents are current then this command does nothing.
docker build -t $IMAGE .

### Run the image to generate an Emacs build.

# Note: we run the container with reduced security to resolve a build
# requirement in Emacs ("gap between BSS and heap error").
# See: http://stackoverflow.com/questions/37544423/how-to-build-emacs-from-source-in-docker-hub-gap-between-bss-and-heap#37561793

docker run \
       --name $CONTAINER \
       --env VERSION=$VERSION \
       --security-opt seccomp=unconfined \
       $IMAGE

### Extract the Emacs artifact from the container
docker cp ${CONTAINER}:/home/travis/emacs-$VERSION-travis.tar.gz .

### Remove the container
if [ "$KEEP_CONTAINER" = "0" ]; then
    docker rm $CONTAINER
fi
