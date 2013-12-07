require 'spec_helper'

describe Evm::System do
  before do
    @system = Evm::System.new('command')
  end

  describe '#run' do
    it 'should run when no arguments' do
      Kernel.should_receive(:system).with('command')

      @system.run
    end

    it 'should run with single argument' do
      Kernel.should_receive(:system).with('command', 'foo')

      @system.run('foo')
    end

    it 'should run with single argument' do
      Kernel.should_receive(:system).with('command', 'foo', 'bar')

      @system.run('foo', 'bar')
    end
  end
end
