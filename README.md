# Emacs Version Manager

## Deprecation Warning!

As Travis is moving towards a container-based infrastructure, hence
sudo is not possible, EVM added support for Travis specific binaries
(ends with `-travis`), which will be installed in `/tmp`.

All `-bin` versions will are deprecated and will be removed. Do not use them!

To run EVM on Travis, set the EVM path to `/tmp`:

```bash
$ evm config path /tmp
```

See https://gist.github.com/rejeep/ebcd57c3af83b049833b for more
information on how to use EVM on Travis.

## Why EVM?

* Did you ever wonder how to install Emacs? Homebrew, apt-get, Emacs
  for OSX, Compile from scratch, etc...

* Are you currently maintaining an Emacs package? How do you know it
  works? Because you have tests of course. Ok, so you know it works on
  your platform and with your Emacs version. But what about all other
  versions that people are using? Does your package work for them?

* EVM provides pre compiled binaries to allow for quick installation
  on CI systems.

## Platform Support

### OSX

Supported!

### GNU/Linux

Supported!

### Windows

Not supported. Need help from someone running Windows.

## Installation

Default installation directory for EVM Emacs versions is
`/usr/local/evm`. This can be changed with the `config` command:

```sh
$ evm config path /foo/bar
```

No matter what installation approach you choose, create the
installation directory and give your user access rights, for example:

```sh
$ sudo mkdir /usr/local/evm
$ sudo chown $USER: /usr/local/evm
```

### Automatic

```sh
$ curl -fsSkL https://raw.github.com/rejeep/evm/master/go | bash
```

Add EVM's `bin` directory to your `PATH`.

```sh
$ export PATH="$HOME/.evm/bin:$PATH"
```

### Homebrew

_NOT ADDED YET_

```sh
$ brew install evm
```

### Ruby gem

```sh
$ gem install evm
```

### Manual

```sh
$ git clone https://github.com/rejeep/evm.git ~/.evm
```

Add EVM's `bin` directory to your `PATH`.

```sh
$ export PATH="$HOME/.evm/bin:$PATH"
```

## Usage

In the Evm `bin` directory, there are a few commands:

* `evm` - Manage Emacs packages
* `emacs`/`evm-emacs` - Emacs shim with currently selected Emacs package

### list

To list all available Emacs versions you can install, run:

```sh
$ evm list
```

The output will look something like this:

```
emacs-23.4
emacs-24.1 [I]
emacs-24.2
* emacs-24.3 [I]
emacs-24.3-travis [I]
...
```

The `[I]` shows what versions are currently installed and the `*`
shows what version is currently selected.

### install <name>

To install a version, run:

```sh
$ evm install version
```

Example:

```sh
$ evm install emacs-24.3
```

### use <name>

To start using a specific package, run:

```sh
$ evm use name
```

Example:

```sh
$ evm use emacs-24.2
```

The Evm binary will update and use that Emacs package.

### disuse

To stop using an EVM binary and restore your personal or system defaults:

```sh
$ evm disuse
```

### uninstall <name>

To uninstall a version, run:

```sh
$ evm uninstall emacs-24.2
```

### bin [name]

Prints the full path to `name`'s Emacs executable. If no name is
specified, use currently selected.

```sh
$ evm bin # /usr/local/evm/emacs-24.5/Emacs.app/Contents/MacOS/Emacs
$ evm bin emacs-24.2 # /usr/local/evm/emacs-24.2/Emacs.app/Contents/MacOS/Emacs
```

### help

For more information, run:

```sh
$ evm --help
```

## Contribution

Be sure to!

Implement the features and don't forget to test it. Run the tests
with:

```sh
$ rspec spec
```

If all passes, send us a
[pull request](https://github.com/rejeep/evm/pulls) with the changes.

### Adding a new Emacs version

Copy an existing recipe in the [recipes](/recipes) directory and make
modifications for the new version.  Also add the new version to the
[Travis configuration](/.travis.yml).

### Adding Travis binary

If you want to contribute a Travis binary, these instructions will help.

1. Install [Docker](https://www.docker.com/)
1. Follow
   [Travis instructions](https://docs.travis-ci.com/user/common-build-problems/#Running-a-Container-Based-Docker-Image-Locally)
   on running a Travis image locally
1. In the docker container, install necessary tools

    ```bash
    docker$ sudo apt-get install build-essential libncurses-dev autoconf automake autogen git texinfo libtool
    ```
1. Download Emacs source

    ```bash
    docker$ export VERSION=25.3 # choose your version
    docker$ wget http://ftpmirror.gnu.org/emacs/emacs-$VERSION.tar.gz
    ```
1. Unzip it

    ```bash
    docker$ tar -xvzf emacs-$VERSION.tar.gz
    ```
1. Compile and Install Emacs (follow
   [these instructions](http://stackoverflow.com/questions/37544423/how-to-build-emacs-from-source-in-docker-hub-gap-between-bss-and-heap#37561793)
   if you have a `"gap between BSS and heap error"`)

    ```bash
    docker$ cd emacs-$VERSION
    docker$ ./autogen.sh # for snapshot
    docker$ ./configure --with-x-toolkit=no --without-x --without-all --with-gnutls --prefix=/tmp/emacs-$VERSION-travis
    docker$ make bootstrap
    docker$ make install
    ```
1. Tar it

    ```bash
    docker$ tar -C /tmp --remove-files -cvzf ~/emacs-$VERSION-travis.tar.gz emacs-$VERSION-travis
    ```

1. Copy the tarball from the docker container to the host

    ```bash
    docker$ exit
    $ docker cp <containerId>:/home/travis/emacs-$VERSION-travis.tar.gz .
    ```

1. Create a new recipe and make a pull request.

1. Ask maintainer to add a new release and add the binary.
