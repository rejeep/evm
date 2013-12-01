require 'spec_helper'

describe Evm::Os do
  describe '#osx?' do
    it 'should be osx when osx' do
      stub_const('RUBY_PLATFORM', 'x86_64-darwin12.3.0')

      Evm::Os.osx?.should be_true
    end

    it 'should not be osx when linux' do
      stub_const('RUBY_PLATFORM', 'x86_64-linux')

      Evm::Os.osx?.should be_false
    end
  end

  describe '#linux?' do
    it 'should be linux when linux' do
      stub_const('RUBY_PLATFORM', 'x86_64-linux')

      Evm::Os.linux?.should be_true
    end

    it 'should not be linux when osx' do
      stub_const('RUBY_PLATFORM', 'x86_64-darwin12.3.0')

      Evm::Os.linux?.should be_false
    end
  end

  describe '.platform_name' do
    it 'should be osx when osx' do
      Evm::Os.stub(:osx?).and_return(true)
      Evm::Os.stub(:linux?).and_return(false)

      Evm::Os.platform_name.should == :osx
    end

    it 'should be linux when linux' do
      Evm::Os.stub(:osx?).and_return(false)
      Evm::Os.stub(:linux?).and_return(true)

      Evm::Os.platform_name.should == :linux
    end
  end
end
