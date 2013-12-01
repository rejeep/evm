module Evm
  module Command
    class Use
      def initialize(package_name, options = {})
        unless package_name
          raise Evm::Exception.new('The use command requires an argument')
        end

        package = Evm::Package.find(package_name)

        if package.installed?
          package.use!
        else
          raise Evm::Exception.new("Package not installed: #{package_name}")
        end
      end
    end
  end
end
