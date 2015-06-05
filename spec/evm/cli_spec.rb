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

  it 'should support force option' do
    @foo.should_receive(:new).with('bar', :force => true)

    Evm::Cli.parse(['foo', 'bar', '--force'])
  end

  it 'should support use option' do
    @foo.should_receive(:new).with('bar', :use => true)

    Evm::Cli.parse(['foo', 'bar', '--use'])
  end

  it 'should support skip option' do
    @foo.should_receive(:new).with('bar', :skip => true)

    Evm::Cli.parse(['foo', 'bar', '--skip'])
  end

  it 'should print usage and die if option --help/-h' do
    @foo.stub(:new)

    Evm.should_receive(:print_usage_and_exit)

    Evm::Cli.parse(['foo', '--help', 'bar'])
  end

  it 'should print message and exit if evm exception creating command class' do
    @foo.stub(:new) do |command, options|
      raise Evm::Exception.new('BooM')
    end

    STDERR.should_receive(:puts).with('BooM')

    expect {
      Evm::Cli.parse(['foo'])
    }.to raise_error(SystemExit)
  end

  it 'should print message and exit if any exception creating command class' do
    @foo.stub(:new) do |command, options|
      raise 'BooM'
    end

    expect {
      Evm::Cli.parse(['foo'])
    }.to raise_error(RuntimeError)

  end

  it 'should print usage and die if no command given' do
    Evm.should_receive(:print_usage_and_exit)

    expect {
      Evm::Cli.parse([])
    }.to raise_error(SystemExit)
  end

  it 'should print message and exit if command not found' do
    STDERR.should_receive(:puts).with('No such command: bar')

    expect {
      Evm::Cli.parse(['bar'])
    }.to raise_error(SystemExit)
  end
end

require 'fakefs/spec_helpers'

describe "EVM::Cli file system operations" do
  # These tests go in a separate describe block so that FakeFS doesn't
  # affect other tests.
  include FakeFS::SpecHelpers

  before do
    @foo = double('Foo')

    stub_const('Evm::Command::Foo', @foo)
  end

  it 'should give an error if install directory does not exist' do
    STDERR.should_receive(:puts).with(/does not exist/)

    expect {
      Evm::Cli.parse(['foo'])
    }.to raise_error(SystemExit)
  end

  # Disabled: Waiting for fix to bug #308 in fakefs (writable? is not
  # mocked correctly).
  xit 'should give an error if install directory is not writable' do

    FileUtils.mkdir_p '/usr/local/evm', mode: 0000
    STDERR.should_receive(:puts).with(/can't write to/)

    expect {
      Evm::Cli.parse(['foo'])
    }.to raise_error(SystemExit)
  end

end
