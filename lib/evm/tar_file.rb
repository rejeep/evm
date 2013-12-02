module Evm
  class TarFile
    def initialize(name)
      @name = name
    end

    def download!
      unless tars_path.exist?
        tars_path.mkdir
      end

      unless tar_path.exist?
        remote_file.save_to(tar_path) do |progress|
          progress_bar.set(progress)
        end
        progress_bar.done
      end
    end

    def extract!
      unless builds_path.exist?
        builds_path.mkdir
      end

      system = Evm::System.new('tar')
      system.run('-xzf', tar_path.to_s, '-C', builds_path.to_s)
    end


    private

    def url
      "https://s3.amazonaws.com/emacs-evm/#{@name}"
    end

    def tars_path
      Evm.local.join('tars')
    end

    def tar_path
      tars_path.join(@name)
    end

    def builds_path
      Evm.local.join('tmp')
    end

    def remote_file
      @remote_file ||= Evm::RemoteFile.new(url)
    end

    def progress_bar
      @progress_bar ||= Evm::ProgressBar.new
    end
  end
end
