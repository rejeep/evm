#!/bin/bash -x

set -o errexit
set -o nounset

function build_emacs() {
    if [ "${VERSION}" != "git-snapshot" ]; then
        wget "http://git.savannah.gnu.org/cgit/emacs.git/snapshot/emacs-${VERSION}.tar.gz"
        tar -xzf "emacs-${VERSION}.tar.gz"
        cd "emacs-${VERSION}" || return 1
    else
        git clone git://git.savannah.gnu.org/emacs.git
        cd emacs || return 1
    fi

    ./autogen.sh && \
        ./configure --with-x-toolkit=no \
                    --without-x \
                    --without-all \
                    --with-gnutls \
                    --prefix="/tmp/${RELEASE}" && \
        make bootstrap && \
        make install && \
        tar -C /tmp -czf "/tmp/${RELEASE}.tar.gz" "${RELEASE}"
}

build_emacs
