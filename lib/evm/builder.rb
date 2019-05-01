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

      def git(url, branch = nil)
        git_repo = Evm::Git.new(build_path)
        if git_repo.exist?
          git_repo.pull
        else
          git_repo.clone(url, branch)
        end
      end

      def tar_xz(url)
        tar_packaged(url, 'xz')
      end

      def tar_gz(url)
        tar_packaged(url, 'gz')
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

      def autogen
        run_command './autogen.sh'
      end

      def configure
        run_command './configure', *@options
      end

      def make(target)
        run_command 'make', target
      end

      def builds_path
        File.join(Evm.config[:path], 'tmp')
      end

      def build_path
        File.join(builds_path, @name)
      end

      def installations_path
        Evm.config[:path]
      end

      def installation_path
        File.join(installations_path, @name)
      end

      def platform_name
        Evm::Os.platform_name
      end

      def copy(from, to)
        run_command "cp -a #{from} #{to}"
      end

      private

      def tar_packaged(url, extension)
        FileUtils.mkdir_p(build_path)
        tar_file_path = File.join(builds_path, @name + '.tar.' + extension)

        remote_file = Evm::RemoteFile.new(url)
        remote_file.download(tar_file_path)

        tar_file = Evm::TarFile.new(tar_file_path)
        tar_file.extract(builds_path, @name)
      end

      def run_command(command, *args)
        Dir.chdir(build_path) do
          system = Evm::System.new(command)
          system.run(*args)
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
