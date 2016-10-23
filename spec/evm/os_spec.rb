require 'spec_helper'

describe Evm::Os do
  describe '.osx?' do
    it 'should be osx when osx' do
      stub_const('RUBY_PLATFORM', 'x86_64-darwin12.3.0')

      expect(Evm::Os.osx?).to be_truthy
    end

    it 'should not be osx when linux' do
      stub_const('RUBY_PLATFORM', 'x86_64-linux')

      expect(Evm::Os.osx?).to be_falsy
    end
  end

  describe '.linux?' do
    it 'should be linux when linux' do
      stub_const('RUBY_PLATFORM', 'x86_64-linux')

      expect(Evm::Os.linux?).to be_truthy
    end

    it 'should not be linux when osx' do
      stub_const('RUBY_PLATFORM', 'x86_64-darwin12.3.0')

      expect(Evm::Os.linux?).to be_falsy
    end
  end

  describe '.platform_name' do
    it 'should be osx when osx' do
      allow(Evm::Os).to receive(:osx?).and_return(true)
      allow(Evm::Os).to receive(:linux?).and_return(false)

      expect(Evm::Os.platform_name).to eq(:osx)
    end

    it 'should be linux when linux' do
      allow(Evm::Os).to receive(:osx?).and_return(false)
      allow(Evm::Os).to receive(:linux?).and_return(true)

      expect(Evm::Os.platform_name).to eq(:linux)
    end
  end
end
