require 'optparse'

module Evm
  module Cli
    def self.parse(argv)
      options = {}

      optparse = OptionParser.new do |opts|
        opts.banner += ' command'

        opts.separator  ''
        opts.separator  'Emacs Version Manager.'
        opts.separator  ''
        opts.separator  'Commands:'
        opts.separator  '        install                      Install package name'
        opts.separator  '        uninstall                    Uninstall package name'
        opts.separator  '        bin [name]                   Show path to Emacs binary for package name'
        opts.separator  '        list                         List all available packages'
        opts.separator  '        use <name>                   Select name as current package'
        opts.separator  '        disuse                       Stop using the current package (remove binary from path but leave installed)'
        opts.separator  '        config [<var> [<value>]]     Get/set the value of configuration variable(s) (like path)'
        opts.separator  '        help                         Display this help message'
        opts.separator  ''
        opts.separator  'Options:'

        opts.on('--force', 'Force install even when already installed') do
          options[:force] = true
        end

        opts.on('--skip', 'Ignore if already installed') do
          options[:skip] = true
        end

        opts.on('--use', 'Select as current package after installing') do
          options[:use] = true
        end

        opts.on_tail('--help', '-h', 'Display this help message') do
          puts opts
          exit
        end
      end

      optparse.parse!(argv)

      command = argv.shift

      if command == 'help' || !command
        puts optparse
        exit
      end

      begin
        const = Evm::Command.const_get(command.capitalize)
      rescue NameError
        raise Evm::Exception, "No such command: #{command}"
      end

      const.new(argv, options)
    end
  end
end
