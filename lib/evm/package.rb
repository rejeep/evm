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

    def client_bin
      Evm::Os.osx? ? nil : File.join(path, 'bin', 'emacsclient')
    end

    def use!
      create_symlinks(bin, "EMACS")
      create_symlinks(client_bin, "EMACSCLIENT") unless Evm::Os.osx?
    end

    def create_symlinks(binary_path, type)
      evm_path = Evm.const_get("EVM_#{type}_PATH")
      path     = Evm.const_get("#{type}_PATH")

      FileUtils.ln_sf(binary_path, evm_path)
      FileUtils.ln_sf(evm_path, path) unless File.symlink?(path)
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
        FileUtils.rm(Evm::EVM_EMACS_PATH)
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
        if File.symlink?(Evm::EVM_EMACS_PATH)
          current_bin_path = File.readlink(Evm::EVM_EMACS_PATH)
          if (match = Regexp.new("#{Evm::LOCAL_PATH}/?(?<current>[^/]+)/.+").match(current_bin_path))
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
