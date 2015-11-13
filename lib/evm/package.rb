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
      [Evm::EMACS_PATH, Evm::EVM_EMACS_PATH].each do |bin_path|
        @file.delete(bin_path) if @file.exists?(bin_path)
        @file.open(bin_path, 'w') do |file|
          file.puts("#!/bin/bash\nexec \"#{bin}\" \"$@\"")
        end
        @file.chmod(0755, bin_path)
      end
      Evm.config[:current] = name
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
      File.join(Evm.config[:path], @name)
    end

    def tmp_path
      File.join(Evm.config[:path], 'tmp')
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
  end
end
