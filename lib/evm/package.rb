module Evm
  class Package
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def current?
      Package.current && Package.current.name == @name
    end

    def installed?
      path.exist?
    end

    def path
      Evm.local.join(@name)
    end

    def bin
      if Evm::Os.osx? && path.join('Emacs.app').exist?
        path.join('Emacs.app', 'Contents', 'MacOS', 'Emacs')
      else
        path.join('bin', 'emacs')
      end
    end

    def use!
      File.open(Package.current_file, 'w') do |file|
        file.write(@name)
      end
    end

    def install!
      Evm::Builder.new(recipe).build!
    end

    def uninstall!
      path.rmtree

      if current?
        Package.current_file.delete
      end
    end

    def to_s
      @name
    end

    def recipe
      Evm::Recipe.find(@name)
    end

    class << self
      def current_file
        Evm.local.join('current')
      end

      def current
        if current_file.exist?
          find(current_file.read)
        end
      end

      def find(package_name)
        recipe = Evm::Recipe.find(package_name)
        if recipe
          Package.new(package_name)
        else
          raise Evm::Exception.new("No such package: #{package_name}")
        end
      end

      def all
        recipes = Evm::Recipe.all
        recipes.map do |recipe|
          Package.new(recipe.name)
        end
      end
    end
  end
end
