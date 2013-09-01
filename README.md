# Emacs Version Manager

_NOTE: This project is at a very early stage. This means that not
everything in this README is implemeneted yet. Help improve by using,
contributing and give feedback._

## Why EVM?

* Did you ever have issues deciding how to install Emacs? Homebrew,
  apt-get, Emacs for OSX, Compile from scratch, etc...

* Are you currently maintaining an Emacs package? How do you know it
  works? Because you have tests of course. Ok, so you know it works on
  your platform and with your Emacs version. But what about all other
  versions that people are using? Does your package work for them?

* I want to use Emacs 24 for work, but at home I have an old script
  running on 23, which I have had no time migrating. How do I install
  both at the same time and easily switch between them?

## Platform Support

### OSX
Supported!

### GNU/Linux
Supported!

### Windows
Not supported. Need help from someone running Windows.

## Installation

Install [Cask](https://github.com/cask/cask).

To automatically install EVM, run this command:

    curl -fsSkL https://raw.github.com/rejeep/evm/master/go | sh

Don't forget to add EVM's bin to your `PATH`.

    $ export PATH="~/.evm/bin:$PATH"
    
## Update

To update EVM, run

    $ evm update
    
Or if you cloned the repository when installing, run

    $ cd ~/.evm && git pull

## Usage

To list all available Emacs versions you can install, run:

    $ evm list

The output will look something like this:

    emacs-23.3
    * emacs-24.1 [I]
    emacs-24.2 [I]

To install a version, run

    $ evm install version
    
Example

    $ evm install emacs-24.2

To start using a specific version, run

    $ evm use version
    
Example

    $ evm use emacs-24.2
    
To uninstall a version, run

    $ evm uninstall emacs-24.2
