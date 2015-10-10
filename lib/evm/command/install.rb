module Evm
  module Command
    class Install
      def initialize(argv, options = {})
        package_name = argv[0]

        unless package_name
          raise Evm::Exception.new('The install command requires an argument')
        end

        package = Evm::Package.find(package_name)

        if package.installed? && (!options[:force] || options[:skip])
          unless options[:skip]
            raise Evm::Exception.new("Already installed #{package_name}")
          end
        else
          if options[:force]
            package.uninstall!
          end

          package.install!

          if options[:use]
            package.use!
          end

          STDOUT.puts "Successfully installed #{package_name}"
        end
      end
    end
  end
end
