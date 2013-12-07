module Evm
  class TarFile
    def initialize(tar_file)
      @tar_file = tar_file
    end

    def extract(extract_to)
      tar '-xzf', @tar_file.to_s, '-C', extract_to.to_s
    end

    private

    def tar(*args)
      @tar ||= Evm::System.new('tar')
      @tar.run(*args)
    end
  end
end
