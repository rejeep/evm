module Evm
  module Cli
    def self.parse(argv)
      options = {}

      if argv.include?('--force')
        options[:force] = !!argv.delete('--force')
      end

      if argv.include?('--help') || argv.include?('-h')
        Evm.print_usage_and_die
      end

      command, argument = argv

      begin
        const = Evm::Command.const_get(command.capitalize)
        const.new(argument, options)
      rescue NameError
        Evm.die "No such command: #{command}"
      rescue Evm::Exception => exception
        Evm.die exception.message
      end
    end
  end
end
