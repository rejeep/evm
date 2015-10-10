require 'json'

module Evm
  class Config
    def initialize(config_file, defaults = {})
      @config_file = config_file
      @defaults = defaults
    end

    def [](type)
      config[type.to_s] || begin
        default = @defaults.find { |key, value| key.to_s == type.to_s }
        default[1] if default
      end
    end

    def []=(type, value)
      write(config.merge(type.to_s => value))
    end


    private

    def config
      if File.exist?(@config_file)
        contents = File.read(@config_file)
        if contents.empty?
          {}
        else
          JSON.parse(contents)
        end
      else
        {}
      end
    end

    def write(config = {})
      File.open(@config_file, 'w') do |file|
        file.write(config.to_json)
      end
    end
  end
end
