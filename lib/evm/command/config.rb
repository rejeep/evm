module Evm
  module Command
    class Config
      def initialize(argv, options = {})
        type, value = argv

        unless Evm::CONFIG_TYPES.include?(type.to_sym)
          raise Evm::Exception, "Invalid config type: #{type}"
        end

        if value
          Evm.config[type] = value
        end

        STDOUT.puts(Evm.config[type])
      end
    end
  end
end
