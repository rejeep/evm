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
end
