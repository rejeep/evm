#!/bin/bash

set -o errexit
set -o nounset

function usage() {
    echo "$(basename "$0") [OPTIONS] VERSION DIST"
    echo
    echo "Build Emacs for execution in Travis CI."
    echo
    echo "  VERSION     Emacs version to build (e.g. 26.3)"
    echo "  DIST        Distribution to build from (e.g. linux-xenial)"
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

    VERSION=${1:-} && shift || true
    DIST=${1:-} && shift || true
    if [ -z "${VERSION}" ] || [ -z "${DIST}" ]; then
        echo "VERSION and DIST are required!"
        usage
        exit 2
    fi
}

# see http://stackoverflow.com/questions/37544423/how-to-build-emacs-from-source-in-docker-hub-gap-between-bss-and-heap#37561793
function build_release() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit 3

    local image="evm-travis-${DIST}-builder:latest"
    local release="emacs-${VERSION}-travis-${DIST}"
    local container="build-${release}"

    docker build -t ${image} -f "${script_dir}/${DIST}.Dockerfile" "${script_dir}"
    docker run \
           --name "${container}" \
           --env VERSION="${VERSION}" \
           --env RELEASE="${release}" \
           --security-opt seccomp=unconfined \
           ${image}
    docker cp "${container}:/tmp/${release}.tar.gz" .
    ${KEEP_CONTAINER} || docker rm "${container}"
}

parse_args "$@"
build_release
