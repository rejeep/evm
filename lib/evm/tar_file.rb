module Evm
  class TarFile
    def initialize(tar_file)
      @tar_file = tar_file
    end

    def extract(extract_to)
      tar '-xzf', @tar_file, '-C', extract_to
    end

    private

    def tar(*args)
      @tar ||= Evm::System.new('tar')
      @tar.run(*args)
    end
  end
end
