require 'open3'
require 'fileutils'

module Evm
  class Builder
    class Dsl
      def initialize
        @options = []
      end

      def recipe(name, &block)
        @name = name

        yield
      end

      def tar_gz(name)
        tar_file = Evm::TarFile.new(name)
        tar_file.download!
        tar_file.extract!
      end

      def osx(&block)
        yield if Evm::Os.osx?
      end

      def linux(&block)
        yield if Evm::Os.linux?
      end

      def option(name, value = nil)
        @options << name
        @options << value if value
      end

      def install(&block)
        yield
      end

      def configure
        run_command './configure', *@options
      end

      def make(target)
        run_command 'make', target
      end

      def build_path
        Evm.local.join('tmp', @name)
      end

      def installation_path
        Evm.local.join(@name)
      end

      def copy(from, to)
        FileUtils.cp_r(from, to)
      end

      private

      def run_command(command, *args)
        Dir.chdir(build_path) do
          system = Evm::System.new(command)
          system.run(args)
        end
      end
    end

    def initialize(recipe)
      @recipe = recipe
    end

    def build!
      dsl = Dsl.new
      dsl.instance_eval(@recipe.read)
    end
  end
end
