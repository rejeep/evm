module Evm
  module Command
    class Use
      def initialize(package_name, options = {})
        package = Evm::Package.find(package_name)
        package.use!
      end
    end
  end
end
