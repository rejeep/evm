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

      command, argument = argv

      if argv.include?('--help') || argv.include?('-h') || command.nil?
        Evm.print_usage_and_exit
      end

      begin
        const = Evm::Command.const_get(command.capitalize)
      rescue NameError => exception
        Evm.abort 'No such command:', command
      end

      begin
        const.new(argument, options)
      rescue Evm::Exception => exception
        Evm.abort exception.message
      end
    end
  end
end
