# Emacs Version Manager

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

EVM installs all Emacs versions under `/usr/local/evm`. This is not
configurable and that is because EVM provides pre compiled binaries,
which unfortunately must run in the directory it was compiled for.

No matter what installation approach you choose, create
`/usr/local/evm` and give your user access rights:

```sh
$ sudo mkdir /usr/local/evm
$ sudo chown $USER:$USER /usr/local/evm
```

### Automatic

```sh
$ curl -fsSkL https://raw.github.com/rejeep/evm/master/go | bash
```

Add EVM's `bin` directory to your `PATH`.

```sh
$ export PATH="~/.evm/bin:$PATH"
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
$ export PATH="~/.evm/bin:$PATH"
```

## Usage

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
emacs-24.3-bin [I]
...
```

The `[I]` shows what versions are currently installed and the `*`
shows what version is currently selected.

_NOTE: The versions with the `-bin` suffix should only to be used for testing._

To install a version, run:

```sh
$ evm install version
```

Example:

```sh
$ evm install emacs-24.3
```

To start using a specific version, run:

```sh
$ evm use version
```

Example:

```sh
$ evm use emacs-24.2
```

To uninstall a version, run:

```sh
$ evm uninstall emacs-24.2
```

For more information, run:

```sh
$ evm help
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
