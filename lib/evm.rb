require 'fileutils'

module Evm
  ROOT_PATH = File.expand_path('..', File.dirname(__FILE__))
  LOCAL_PATH = File.join('/', 'usr', 'local', 'evm')
  BIN_PATH = File.join(ROOT_PATH, 'bin', 'emacs')

  def self.abort(*args)
    STDERR.puts args.join(' ')

    exit 1
  end

  def self.print_usage_and_exit
    Evm.abort <<-EOS
USAGE: evm COMMAND [OPTIONS]

Emacs Version Manager

COMMANDS:
 install <name>             Install package name
 uninstall <name>           Uninstall package name
 bin [name]                 Show path to Emacs binary for package name
 list                       List all available packages
 use <name>                 Select name as current package
 help                       Display this help message

OPTIONS:
 --force                    Force install even when already installed
 --help, -h                 Display this help message
    EOS
  end
end

require 'evm/os'
require 'evm/cli'
require 'evm/recipe'
require 'evm/package'
require 'evm/command'
require 'evm/exception'
require 'evm/builder'
require 'evm/tar_file'
require 'evm/remote_file'
require 'evm/system'
require 'evm/progress_bar'
require 'evm/git'
