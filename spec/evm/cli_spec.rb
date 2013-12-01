require 'spec_helper'

describe Evm::Cli do
  before do
    @foo = double('Foo')

    stub_const('Evm::Command::Foo', @foo)
  end

  it 'should initialize class without argument or option' do
    @foo.should_receive(:new).with(nil, {})

    Evm::Cli.parse(['foo'])
  end

  it 'should initialize class with argument' do
    @foo.should_receive(:new).with('bar', {})

    Evm::Cli.parse(['foo', 'bar'])
  end

  it 'should initialize class with option' do
    @foo.should_receive(:new).with(nil, :force => true)

    Evm::Cli.parse(['foo', '--force'])
  end

  it 'should create command class with argument and option' do
    @foo.should_receive(:new).with('bar', :force => true)

    Evm::Cli.parse(['foo', 'bar', '--force'])
  end

  it 'should print usage and die if option --help/-h' do
    @foo.stub(:new)

    Evm.should_receive(:print_usage_and_die)

    Evm::Cli.parse(['foo', '--help', 'bar'])
  end

  it 'should print message and exit if exception creating command class' do
    @foo.stub(:new) do |command, options|
      raise Evm::Exception.new('BooM')
    end

    Evm.should_receive(:die).with('BooM')

    Evm::Cli.parse(['foo'])
  end

  it 'should print message and exit if command not found' do
    Evm.should_receive(:die).with('No such command: bar')

    Evm::Cli.parse(['bar'])
  end
end
