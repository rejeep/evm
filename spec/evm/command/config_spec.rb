require 'spec_helper'

describe Evm::Command::Config do
  let :config do
    {}
  end

  before do
    allow(Evm).to receive(:config).and_return(config)
    stub_const('Evm::CONFIG_TYPES', [:foo])
  end

  it 'raises exception unless valid type' do
    expect {
      described_class.new(['bar'])
    }.to raise_error('Invalid config type: bar')
  end

  context 'get' do
    it 'prints type value' do
      config['foo'] = 'FOO'
      expect(STDOUT).to receive(:puts).with('FOO')
      described_class.new(['foo'])
    end
  end

  context 'set' do
    it 'sets type to value and prints value' do
      expect(STDOUT).to receive(:puts).with('BAR')
      described_class.new(['foo', 'BAR'])
      expect(config['foo']).to eq('BAR')
    end
  end
end
