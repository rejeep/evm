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

  it 'can set type to value and get value' do
    subject[:foo] = 'bar'
    expect(subject[:foo]).to eq('bar')
  end

  it 'supports both string and symbol type' do
    subject[:foo] = 'bar'
    expect(subject['foo']).to eq('bar')
  end

  it 'returns nil unless type is set to a value' do
    expect(subject[:foo]).to be_nil
  end

  it 'returns default value if any and type not set' do
    expect(subject[:baz]).to eq('qux')
    subject[:baz] = 'QUX'
    expect(subject[:baz]).to eq('QUX')
  end
end
