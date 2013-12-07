module Evm
  class System
    def initialize(executable)
      @executable = executable
    end

    def run(*args)
      Kernel.exec(@executable, *args)
    end
  end
end
