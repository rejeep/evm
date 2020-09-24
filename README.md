# Emacs Version Manager

[![Gem Version](https://badge.fury.io/rb/evm.svg)](http://badge.fury.io/rb/evm)
[![Build Status](https://travis-ci.org/rejeep/evm.svg)](https://travis-ci.org/rejeep/evm)
[![Coverage Status](https://coveralls.io/repos/rejeep/evm/badge.svg?branch=master&service=github)](https://coveralls.io/github/rejeep/evm?branch=master)

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

* EVM provides Linux pre-compiled binaries to allow for quick installation
  on CI systems.

## Platform Support

### OSX

Supported! (currently no pre-compiled binaries for CI)

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

2. Run the generate script:

```bash
$ docker/build-release.sh 27.1 linux-xenial
$ ls emacs-27.1-travis-linux-xenial.tar.gz
emacs-27.1-travis-linux-xenial.tar.gz
```

Caution: Be prepared to wait!

If you are running this script for the first time, it will need to
create the build image, which means downloading a large (> 10 GB) base
image from Travis CI, and further configuring it with the tools needed
to compile Emacs from source.

In addition, the Emacs build takes time and generates a fair amount of
console output.

3. Create a new recipe and make a pull request.

4. Ask maintainer to add a new release and add the binary.
