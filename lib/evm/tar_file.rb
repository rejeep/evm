module Evm
  class TarFile
    def initialize(tar_file)
      @tar_file = tar_file
    end

    def extract(extract_to, name = nil)
      args = []
      args << '-xf'
      args << @tar_file
      args << '-C'

      if name
        args << File.join(extract_to, name)
        args << '--strip-components'
        args << '1'
      else
        args << extract_to
      end

      tar(*args)
    end

    private

    def tar(*args)
      @tar ||= Evm::System.new('tar')
      @tar.run(*args)
    end
  end
end
