require 'pathname'

module Evm
  def self.root
    Pathname.new(__FILE__).parent.parent.expand_path
  end

  def self.local
    Pathname.new('/').join('usr', 'local', 'evm')
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
require 'evm/system'
