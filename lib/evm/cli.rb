module Evm
  module Cli
    def self.parse(argv)
      options = {}

      if argv.include?('--force')
        options[:force] = !!argv.delete('--force')
      end

      if argv.include?('--use')
        options[:use] = !!argv.delete('--use')
      end

      if argv.include?('--help') || argv.include?('-h')
        Evm.print_usage_and_exit
      end

      command, argument = argv

      begin
        const = Evm::Command.const_get(command.capitalize)
      rescue NameError => exception
        Evm.abort 'No such command:', command
      end

      begin
        const.new(argument, options)
      rescue => exception
        Evm.abort exception.message
      end
    end
  end
end
