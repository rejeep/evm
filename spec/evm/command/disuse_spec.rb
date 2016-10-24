require 'spec_helper'

describe Evm::Command::Disuse do
  it 'should disuse package name if package selected' do
    allow(Evm::Package).to receive(:current) do
      package = double('package')
      expect(package).to receive(:disuse!)
      package
    end

    Evm::Command::Disuse.new([])
  end

  it 'should raise exception if no package selected' do
    expect {
      Evm::Command::Disuse.new([])
    }.to raise_error('No package currently selected')
  end
end
