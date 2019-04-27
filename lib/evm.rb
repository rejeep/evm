require 'fileutils'

module Evm
  class Exception < StandardError; end

  ROOT_PATH = File.expand_path('..', File.dirname(__FILE__))
  LOCAL_PATH = File.join('/', 'usr', 'local', 'evm')
  EMACS_PATH = File.join(ROOT_PATH, 'bin', 'emacs')
  EVM_EMACS_PATH = File.join(ROOT_PATH, 'bin', 'evm-emacs')
  CONFIG_FILE = File.join(ROOT_PATH, '.config')
  CONFIG_KEYS = [:path]

  def self.config
    Evm::Config.new(CONFIG_FILE, path: LOCAL_PATH)
  end
end

require 'evm/os'
require 'evm/cli'
require 'evm/recipe'
require 'evm/package'
require 'evm/command'
require 'evm/builder'
require 'evm/tar_file'
require 'evm/remote_file'
require 'evm/system'
require 'evm/git'
require 'evm/config'
