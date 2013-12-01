module Evm
  module Command
    class Install
      def initialize(package_name, options = {})
        unless package_name
          raise Evm::Exception.new('The install command requires an argument')
        end

        package = Evm::Package.find(package_name)

        if options[:force]
          package.uninstall!
        end

        if package.installed?
          raise Evm::Exception.new("Already installed #{package_name}")
        else
          package.install!

          STDOUT.puts "Successfully installed #{package_name}"
        end
      end
    end
  end
end
