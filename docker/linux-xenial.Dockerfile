FROM travisci/ci-sardonyx:packer-1564753982-0c06deb6

# hadolint ignore=DL3008
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        autoconf \
        autogen \
        automake \
        build-essential \
        git \
        libgnutls-dev \
        libncurses-dev \
        libtool \
        texinfo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER travis
WORKDIR /home/travis
COPY build-emacs.sh /home/travis/
CMD ["./build-emacs.sh"]
