require 'open-uri'

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
        File.open(tar_path, 'wb') do |write_file|
          open(url, 'rb') do |read_file|
            write_file.write(read_file.read)
          end
        end
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
  end
end
