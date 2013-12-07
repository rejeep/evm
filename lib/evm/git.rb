module Evm
  class Git
    def initialize(path)
      @path = path
    end

    def exist?
      @path.exist?
    end

    def clone(url)
      git 'clone', url, @path.to_s
    end

    def pull
      Dir.chdir(@path.to_s) do
        git 'pull'
      end
    end


    private

    def git(*args)
      @git ||= Evm::System.new('git')
      @git.run(*args)
    end
  end
end
