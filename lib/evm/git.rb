module Evm
  class Git
    def initialize(path)
      @path = path
    end

    def exist?
      File.exist?(@path)
    end

    def clone(url, branch = nil)
      args = 'clone', url, @path
      args << "--branch=#{branch}" if branch
      git(*args)
    end

    def pull
      Dir.chdir(@path) do
        git 'pull'
      end
    end


    private

    def git(*args)
      @git ||= Evm::System.new('git')
      @git.run(*args, '--depth=1')
    end
  end
end
