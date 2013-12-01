Gem::Specification.new do |s|
  s.name        = 'evm'
  s.version     = '0.3.1'
  s.summary     = 'Emacs Version Manager'
  s.description = 'EVM is a command-line tool that allows you to install multiple Emacs versions.'
  s.authors     = ['Johan Andersson']
  s.email       = 'johan.rejeep@gmail.com'
  s.files       = [
    'lib/evm/builder.rb',
    'lib/evm/cli.rb',
    'lib/evm/command/bin.rb',
    'lib/evm/command/install.rb',
    'lib/evm/command/list.rb',
    'lib/evm/command/uninstall.rb',
    'lib/evm/command/use.rb',
    'lib/evm/command.rb',
    'lib/evm/exception.rb',
    'lib/evm/os.rb',
    'lib/evm/package.rb',
    'lib/evm/recipe.rb',
    'lib/evm/system.rb',
    'lib/evm/tar_file.rb',
    'lib/evm.rb',
    'recipes/emacs-23.4-bin.rb',
    'recipes/emacs-23.4.rb',
    'recipes/emacs-24.1-bin.rb',
    'recipes/emacs-24.1.rb',
    'recipes/emacs-24.2-bin.rb',
    'recipes/emacs-24.2.rb',
    'recipes/emacs-24.3-bin.rb',
    'recipes/emacs-24.3.rb'
  ]
  s.homepage    = 'http://github.com/rejeep/evm'
  s.license     = 'MIT'
  s.executables = ['evm', 'emacs']
end
