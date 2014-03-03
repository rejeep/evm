module Evm
  class System
    def initialize(executable)
      @executable = executable
    end

    def run(*args)
      succeeded = Kernel.system(@executable, *args)
      unless succeeded
        print "Failed! See logs above for error."
        Kernel.exit($?.exitstatus)
      end
    end
  end
end
