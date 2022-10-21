module Evm
  class Git
    def initialize(path)
      @path = path
    end

    def exist?
      File.exist?(@path)
    end

    def clone(url, branch = nil, commit = nil)
      args = 'clone', url, @path
      args << "--branch=#{branch}" if branch
     if commit == nil
        args << '--depth=1'
      end
      git(*args)
    end

    def pull(commit = nil)
      Dir.chdir(@path) do
        args = 'pull'
        args = 'pull', '--depth=2000000' if commit
        git(*args)
      end
    end

    def reset(commit = nil)
      Dir.chdir(@path) do
        args = 'reset', '--hard'
        args << commit if commit
        git(*args)
      end
    end

    private

    def git(*args)
      @git ||= Evm::System.new('git')
      @git.run(*args)
    end
  end
end
