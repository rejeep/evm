require 'spec_helper'

describe Evm::Command::Config do
  let :config do
    {}
  end

  before do
    allow(config).to receive(:all).and_return(config)
    allow(Evm).to receive(:config).and_return(config)
    stub_const('Evm::CONFIG_KEYS', [:foo])
  end

  it 'raises exception unless valid key' do
    expect {
      described_class.new(['bar'])
    }.to raise_error('Invalid config key: bar')
  end

  context 'no arguments' do
    it 'prints all keys and values' do
      config['foo'] = 'FOO'
      expect(STDOUT).to receive(:puts).with('foo => FOO')
      described_class.new([])
    end
  end

  context 'get' do
    it 'prints key value' do
      config['foo'] = 'FOO'
      expect(STDOUT).to receive(:puts).with('FOO')
      described_class.new(['foo'])
    end
  end

  context 'set' do
    it 'sets key to value and prints value' do
      expect(STDOUT).to receive(:puts).with('BAR')
      described_class.new(['foo', 'BAR'])
      expect(config['foo']).to eq('BAR')
    end
  end
end
