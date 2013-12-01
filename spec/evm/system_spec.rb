require 'spec_helper'

describe Evm::System do
  before do
    @system = Evm::System.new('command')
  end

  describe '#run' do
    it 'should run when no arguments' do
      Kernel.should_receive(:system).with('command').and_return(true)

      @system.run
    end

    it 'should run with single argument' do
      Kernel.should_receive(:system).with('command foo').and_return(true)

      @system.run('foo')
    end

    it 'should run with single argument' do
      Kernel.should_receive(:system).with('command foo bar').and_return(true)

      @system.run('foo', 'bar')
    end

    it 'should raise exception if command failed' do
      Kernel.stub(:system).and_return(false)

      expect {
        @system.run('foo', 'bar')
      }.to raise_error('An error occurred running command: command foo bar')
    end
  end
end
