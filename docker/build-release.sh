#!/bin/bash

set -o errexit
set -o nounset

function usage() {
    echo "$(basename "$0") [OPTIONS] VERSION"
    echo
    echo "Build Emacs for execution in Travis CI."
    echo
    echo "  VERSION     Emacs version to build"
    echo
    echo "Options:"
    echo "  -h          Show help"
    echo "  -k          Keep Docker container after successful build (default: false)"
}

function parse_args() {
    KEEP_CONTAINER=false
    local option
    while getopts "hk" option; do
        case ${option} in
            h) usage
               exit 0
               ;;
            k) KEEP_CONTAINER=true
               ;;
            *) usage
               exit 1
               ;;
        esac
    done
    shift $((OPTIND - 1))

    VERSION=${1:-} && shift
    if [ -z "${VERSION}" ]; then
        echo "VERSION is required!"
        usage
        exit 2
    fi
}

# see http://stackoverflow.com/questions/37544423/how-to-build-emacs-from-source-in-docker-hub-gap-between-bss-and-heap#37561793
function build_release() {
    cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" || exit 3

    local image="evm-travis-builder:latest"
    local container="build-emacs-${VERSION}-travis"

    docker build -t ${image} .
    docker run \
           --name "${container}" \
           --env VERSION="${VERSION}" \
           --security-opt seccomp=unconfined \
           ${image}
    docker cp "${container}:/tmp/emacs-${VERSION}-travis.tar.gz" .
    ${KEEP_CONTAINER} || docker rm "${container}"
}

parse_args "$@"
build_release
