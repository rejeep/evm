module Evm
  class System
    def initialize(executable)
      @executable = executable
    end

    def run(*args)
      command = build_command(args)
      unless Kernel.system(command)
        raise Evm::Exception.new("An error occurred running command: #{command}")
      end
    end

    private

    def build_command(args)
      ([@executable] + args).join(' ')
    end
  end
end
