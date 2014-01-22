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
      FileUtils.ln_sf(bin, Evm::BIN_PATH)
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
        FileUtils.rm(Evm::BIN_PATH)
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
      def current
        if File.symlink?(Evm::BIN_PATH)
          current_bin_path = File.readlink(Evm::BIN_PATH)
          if (match = Regexp.new("#{Evm::LOCAL_PATH}/?(?<current>[^/]+)/.+").match(File.readlink(Evm::BIN_PATH)))
            find match[:current]
          end
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
