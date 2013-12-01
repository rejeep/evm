module Evm
  module Command
    class Uninstall
      def initialize(package_name, options = {})
        unless package_name
          raise Evm::Exception.new('The uninstall command requires an argument')
        end

        package = Evm::Package.find(package_name)

        if package.installed?
          package.uninstall!

          STDOUT.puts "Successfully uninstalled #{package_name}"
        else
          raise Evm::Exception.new("Not installed #{package_name}")
        end
      end
    end
  end
end
