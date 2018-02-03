FROM travisci/ci-garnet:packer-1512502276-986baf0

# Warning: Travis CI docker images are HUGE!
#
# Reserve some time and make sure you have a stable network connection
# before attempting to build this image the first time.  Since Travis
# CI engineering seems to rebuild their images continuously, be sure
# to check the version label above and update it from time to time.
#
# For more information:
#
#   https://docs.travis-ci.com/user/common-build-problems/#Troubleshooting-Locally-in-a-Docker-Image
#   https://hub.docker.com/u/travisci/


# Install development tools required to build Emacs from source

RUN apt-get update -y \
 && apt-get install -y \
      autoconf \
      autogen \
      automake \
      build-essential \
      git \
      libncurses-dev \
      libtool \
      texinfo

# Travis CI sets the CMD to /sbin/init which is not needed here. We
# just need the OS with compatible development toolchain. For
# convenience we're setting CMD to the build-travis.sh script bash so
# the container can be launched directly.

USER travis
WORKDIR /home/travis
CMD ["./build-emacs.sh"]
ADD docker/build-emacs.sh /home/travis/

# We need a default, but this can always be overridden, e.g.
#    docker run --env VERSION=25.3 ...

ENV VERSION=26.0.91
