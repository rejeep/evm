require 'spec_helper'

describe Evm::Cli do
  let :foo do
    double('Foo')
  end

  before do
    stub_const('Evm::Command::Foo', foo)
  end

  it 'should initialize class without argument or option' do
    expect(foo).to receive(:new).with([], {})

    Evm::Cli.parse(['foo'])
  end

  it 'should initialize class with argument' do
    expect(foo).to receive(:new).with(['bar'], {})

    Evm::Cli.parse(['foo', 'bar'])
  end

  it 'should initialize class with option' do
    expect(foo).to receive(:new).with([], :force => true)

    Evm::Cli.parse(['foo', '--force'])
  end

  it 'should support force option' do
    expect(foo).to receive(:new).with(['bar'], :force => true)

    Evm::Cli.parse(['foo', 'bar', '--force'])
  end

  it 'should support use option' do
    expect(foo).to receive(:new).with(['bar'], :use => true)

    Evm::Cli.parse(['foo', 'bar', '--use'])
  end

  it 'should support skip option' do
    expect(foo).to receive(:new).with(['bar'], :skip => true)

    Evm::Cli.parse(['foo', 'bar', '--skip'])
  end

  it 'should print message and exit if command not found' do
    expect {
      Evm::Cli.parse(['bar'])
    }.to raise_error('No such command: bar')
  end

  context 'command aliases' do
    it 'aliases i to install' do
      install = double('install')
      expect(install).to receive(:new)
      stub_const('Evm::Command::Install', install)
      Evm::Cli.parse(['i'])
    end
  end
end
