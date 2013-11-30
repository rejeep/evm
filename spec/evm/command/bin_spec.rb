require 'spec_helper'

describe Evm::Command::Bin do
  it 'should print current bin when not specified' do
    Evm::Package.stub(:current) do |package_name, options|
      double('package', :bin => 'BIN')
    end

    STDOUT.should_receive(:puts).with('BIN')

    Evm::Command::Bin.new()
  end

  it 'should print specified bin when specified' do
    Evm::Package.stub(:find) do |package_name, options|
      double('package', :bin => 'BIN')
    end

    STDOUT.should_receive(:puts).with('BIN')

    Evm::Command::Bin.new('foo')
  end

  it 'should raise exception when no current and no specified' do
    Evm::Package.stub(:find)
    Evm::Package.stub(:current)

    expect {
      Evm::Command::Bin.new()
    }.to raise_error('No current selected')
  end
end
