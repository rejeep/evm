module Evm
  module Cli
    def self.parse(argv)
      options = {}

      if argv.include?('--force')
        options[:force] = !!argv.delete('--force')
      end

      if argv.include?('--skip')
        options[:skip] = !!argv.delete('--skip')
      end

      if argv.include?('--use')
        options[:use] = !!argv.delete('--use')
      end

      command, argument = argv

      if argv.include?('--help') || argv.include?('-h') || command.nil?
        Evm.print_usage_and_exit
      end

      unless File.directory?('/usr/local/evm')
        Evm.abort "Directory '/usr/local/evm' does not exist. Did you forget to run 'sudo mkdir /usr/local/evm'?"
      end

      unless File.stat('/usr/local/evm').writable?
        Evm.abort "You can't write to '/usr/local/evm'. Did you forget to run 'sudo chown $USER: /usr/local/evm'?"
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
