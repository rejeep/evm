#! /bin/bash -x

if [ "$VERSION" != "git-snapshot" ]; then
    # numbered versions are prepackaged as .tar.gz
    wget http://git.savannah.gnu.org/cgit/emacs.git/snapshot/emacs-$VERSION.tar.gz
    tar -xzf emacs-$VERSION.tar.gz
    cd emacs-$VERSION
else
    # "git-snapshot" means clone the master branch
    # REPO=git://git.savannah.gnu.org/emacs.git
    REPO=git://git.sv.gnu.org/emacs.git
    GIT_TRACE=1 GIT_CURL_VERBOSE=1 git clone --verbose -b master $REPO
    cd emacs
fi

./autogen.sh && \
./configure --with-x-toolkit=no \
            --without-x \
            --without-all \
            --with-gnutls \
            --prefix=/tmp/emacs-$VERSION-travis && \
make bootstrap && \
make install && \
tar -C /tmp -czf ~/emacs-$VERSION-travis.tar.gz emacs-$VERSION-travis
