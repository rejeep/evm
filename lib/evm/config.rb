require 'json'

module Evm
  class Config
    def initialize(config_file, defaults = {})
      @config_file = config_file
      @defaults = defaults
    end

    def [](key)
      config[key.to_s] || begin
        _, found_value = @defaults.find { |k, v| k.to_s == key.to_s }
        found_value
      end
    end

    def []=(key, value)
      write(config.merge(key.to_s => value))
    end

    def all
      Hash[@defaults.collect{|k, v| [k.to_s, v]}].merge(config)
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
