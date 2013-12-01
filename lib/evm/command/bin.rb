module Evm
  module Command
    class Bin
      def initialize(package_name = nil, options = {})
        if package_name
          package = Evm::Package.find(package_name)
        else
          package = Evm::Package.current
        end

        if package
          STDOUT.puts package.bin
        else
          raise Evm::Exception.new('No current selected')
        end
      end
    end
  end
end
