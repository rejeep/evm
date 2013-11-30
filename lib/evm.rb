require 'pathname'

module Evm
  def self.root
    Pathname.new(__FILE__).parent.parent.expand_path
  end

  def self.local
    Pathname.new('/').join('usr', 'local', 'evm')
  end
end

require 'os'
require 'cli'
require 'recipe'
require 'package'
require 'command'
require 'exception'
