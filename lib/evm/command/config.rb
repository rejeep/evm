module Evm
  module Command
    class Config
      def initialize(argv, options = {})
        key, value = argv

        unless key
          Evm.config.all.each do |k, v|
            STDOUT.puts("#{k} => #{v}")
          end
          return
        end

        unless Evm::CONFIG_KEYS.include?(key.to_sym)
          raise Evm::Exception, "Invalid config key: #{key}"
        end

        if value
          Evm.config[key] = value
        end

        STDOUT.puts(Evm.config[key])
      end
    end
  end
end
