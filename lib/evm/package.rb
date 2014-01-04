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
      File.file?(bin) && File.executable?(bin)
    end

    def bin
      if Evm::Os.osx? && File.exist?(File.join(path, 'Emacs.app'))
        File.join(path, 'Emacs.app', 'Contents', 'MacOS', 'Emacs')
      else
        File.join(path, 'bin', 'emacs')
      end
    end

    def use!
      File.open(Package.current_file, 'w') do |file|
        file.write(@name)
      end
    end

    def install!
      unless File.exist?(path)
        Dir.mkdir(path)
      end

      unless File.exist?(tmp_path)
        Dir.mkdir(tmp_path)
      end

      Evm::Builder.new(recipe).build!
    end

    def uninstall!
      if File.exist?(path)
        FileUtils.rm_r(path)
      end

      if current?
        File.delete(Package.current_file)
      end
    end

    def to_s
      @name
    end

    def recipe
      Evm::Recipe.find(@name)
    end

    def path
      File.join(Evm::LOCAL_PATH, @name)
    end

    def tmp_path
      File.join(Evm::LOCAL_PATH, 'tmp')
    end

    class << self
      def current_file
        File.join(Evm::LOCAL_PATH, 'current')
      end

      def current
        if File.exist?(current_file)
          find File.read(current_file)
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
