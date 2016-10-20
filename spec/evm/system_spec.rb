require 'spec_helper'

describe Evm::System do
  before do
    @system = Evm::System.new('command')
  end

  describe '#run' do
    it 'should run when no arguments' do
      expect(Kernel).to receive(:system).with('command').and_return(true)

      @system.run
    end

    it 'should run with single argument' do
      expect(Kernel).to receive(:system).with('command', 'foo').and_return(true)

      @system.run('foo')
    end

    it 'should run with multiple arguments' do
      expect(Kernel).to receive(:system).with('command', 'foo', 'bar').and_return(true)

      @system.run('foo', 'bar')
    end

    it 'should exit if the command fails' do
      expect(Kernel).to receive(:exit)

      # Based on http://stackoverflow.com/a/4589517
      system = Evm::System.new('(exit 21)')

      system.run
    end
  end
end
