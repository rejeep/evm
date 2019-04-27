require 'tempfile'
require 'spec_helper'

describe Evm::Config do
  let :config_file do
    Tempfile.new('foo')
  end

  let :defaults do
    { baz: 'qux' }
  end

  subject do
    described_class.new(config_file, defaults)
  end

  it 'can set key to value and get value' do
    subject[:foo] = 'bar'
    expect(subject[:foo]).to eq('bar')
  end

  it 'supports both string and symbol key' do
    subject[:foo] = 'bar'
    expect(subject['foo']).to eq('bar')
  end

  it 'returns nil unless key is set to a value' do
    expect(subject[:foo]).to be_nil
  end

  it 'returns default value if any and key not set' do
    expect(subject[:baz]).to eq('qux')
    subject[:baz] = 'QUX'
    expect(subject[:baz]).to eq('QUX')
  end

  it 'includes defaults in all config' do
    expect(subject.all).to eq({ 'baz' => 'qux' })
  end

  it 'includes non-defaults in all config' do
    subject[:foo] = 'bar'
    expect(subject.all).to eq({ 'baz' => 'qux', 'foo' => 'bar' })
  end

  it 'overrides defaults in all config' do
    subject[:baz] = 'QUX'
    expect(subject.all).to eq({ 'baz' => 'QUX' })
  end
end
