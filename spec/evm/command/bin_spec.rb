require 'spec_helper'

describe Evm::Command::Bin do
  it 'should print current bin when not specified' do
    allow(Evm::Package).to receive(:current) do |package_name, options|
      double('package', :bin => 'BIN')
    end

    expect(STDOUT).to receive(:puts).with('BIN')

    Evm::Command::Bin.new([])
  end

  it 'should print specified bin when specified' do
    allow(Evm::Package).to receive(:find) do |package_name, options|
      double('package', :bin => 'BIN')
    end

    expect(STDOUT).to receive(:puts).with('BIN')

    Evm::Command::Bin.new(['foo'])
  end

  it 'should raise exception when no current and no specified' do
    allow(Evm::Package).to receive(:find)
    allow(Evm::Package).to receive(:current)

    expect {
      Evm::Command::Bin.new([])
    }.to raise_error('No current selected')
  end
end
