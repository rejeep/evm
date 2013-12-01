module Evm
  module Os
    def self.osx?
      RUBY_PLATFORM.downcase.include?('darwin')
    end

    def self.linux?
      RUBY_PLATFORM.downcase.include?('linux')
    end

    def self.platform_name
      if osx?
        :osx
      elsif linux?
        :linux
      end
    end
  end
end
