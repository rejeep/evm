module Evm
  module Command
    class Disuse
      def initialize(argv, options = {})
        package = Evm::Package.current

        if package
          package.disuse!
        else
          raise Evm::Exception.new('No package currently selected')
        end
      end
    end
  end
end
