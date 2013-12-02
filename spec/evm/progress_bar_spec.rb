require 'spec_helper'

describe Evm::ProgressBar do
  before do
    @output = ''

    @progress_bar = Evm::ProgressBar.new
    @progress_bar.stub(:puts) do |*args|
      @output << args.join + "\n"
    end
    @progress_bar.stub(:print) do |*args|
      @output << args.join
    end
  end

  describe '#set' do
    it 'should handle 0' do
      @progress_bar.set(0)
      @output.should == "\n\e[1A\e[K[%s] 0%\n" % (' ' * 100)
    end

    it 'should handle 100' do
      @progress_bar.set(100)
      @output.should == "\n\e[1A\e[K[%s] 100%\n" % ('-' * 100)
    end

    it 'should only print newline at beginning first time' do
      @progress_bar.set(10)
      @output.should == "\n\e[1A\e[K[----------%s] 10%\n" % (' ' * 90)
      @output = ''

      @progress_bar.set(11)
      @output.should == "\e[1A\e[K[-----------%s] 11%\n" % (' ' * 89)
    end

    it 'should convert to integer' do
      @progress_bar.set(10.3)
      @output.should == "\n\e[1A\e[K[----------%s] 10%\n" % (' ' * 90)
    end

    it 'should raise exception if below 0' do
      expect {
        @progress_bar.set(-1)
      }.to raise_exception('Invalid progress -1, must be between 0 and 100')
    end

    it 'should raise exception if above 100' do
      expect {
        @progress_bar.set(101)
      }.to raise_exception('Invalid progress 101, must be between 0 and 100')
    end
  end

  describe '#done' do
    it 'should set 100' do
      @progress_bar.done
      @output.should == "\n\e[1A\e[K[%s] 100%\n" % ('-' * 100)
    end
  end
end
