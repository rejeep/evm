FROM travisci/ci-garnet:packer-1515445631-7dfb2e1

# hadolint ignore=DL3008
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        autoconf \
        autogen \
        automake \
        build-essential \
        git \
        libncurses-dev \
        libtool \
        texinfo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER travis
WORKDIR /home/travis
COPY docker/build-emacs.sh /home/travis/
CMD ["./build-emacs.sh"]
