module Evm
  class Package
    attr_reader :name

    def initialize(name, options = {})
      @name = name
      @file = options[:file] || File
    end

    def current?
      Package.current && Package.current.name == @name
    end

    def installed?
      @file.directory?(path)
    end

    def bin
      if Evm::Os.osx? && @file.exists?(File.join(path, 'Emacs.app'))
        File.join(path, 'Emacs.app', 'Contents', 'MacOS', 'Emacs')
      else
        emacs_bin = File.join(path, 'bin', 'emacs')
        if @file.exists?(emacs_bin)
          emacs_bin
        else
          remacs_bin = File.join(path, 'bin', 'remacs')
          if @file.exists?(remacs_bin)
            remacs_bin
          end
        end
      end
    end

    def use!
      delete_shims!
      [Evm::EMACS_PATH, Evm::EVM_EMACS_PATH].each do |bin_path|
        @file.open(bin_path, 'w') do |file|
          file.puts("#!/bin/bash\nexec \"#{bin}\" \"$@\"")
        end
        @file.chmod(0755, bin_path)
      end
      Evm.config[:current] = name
    end

    def disuse!
      delete_shims!
      Evm.config[:current] = nil
    end

    def delete_shims!
      [Evm::EMACS_PATH, Evm::EVM_EMACS_PATH].each do |bin_path|
        @file.delete(bin_path) if @file.exists?(bin_path)
      end
    end

    def install!
      begin
        unless installed?
          FileUtils.mkdir_p(path)
        end
        Evm::Builder.new(recipe).build!
      rescue ::Exception
        uninstall!
        raise
      end
    end

    def uninstall!
      if installed?
        FileUtils.rm_r(path)
      end

      if current?
        disuse!
      end
    end

    def to_s
      @name
    end

    def recipe
      Evm::Recipe.find(@name)
    end

    def path
      File.join(Evm.config[:path], @name)
    end

    class << self
      def current
        if (name = Evm.config[:current])
          find(name)
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

    private :delete_shims!
  end
end
