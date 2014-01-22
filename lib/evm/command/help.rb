module Evm
  module Command
    class Help
      def initialize(*args)
        Evm.print_usage_and_exit
      end
    end
  end
end
