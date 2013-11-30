module Evm
  module Cli
    def self.parse(argv)
      options = {}

      if argv.include?('--force')
        options[:force] = !!argv.delete('--force')
      end

      command, argument = argv

      begin
        Evm::Command.const_get(command.capitalize).new(argument, options)
      rescue Evm::Exception => exception
        STDERR.puts exception.message

        exit 1
      end
    end
  end
end
