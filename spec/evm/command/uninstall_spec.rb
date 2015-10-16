require 'spec_helper'

describe Evm::Command::Uninstall do
  it 'should uninstall if installed' do
    Evm::Package.stub(:find) do |package_name|
      package = double('package')
      package.should_receive(:uninstall!)
      package.stub(:installed?).and_return(true)
      package
    end

    STDOUT.should_receive(:puts).with('Successfully uninstalled foo')

    Evm::Command::Uninstall.new(['foo'])
  end

  it 'should raise exception if not installed' do
    Evm::Package.stub(:find) do |package_name|
      package = double('package')
      package.should_not_receive(:uninstall!)
      package.stub(:installed?).and_return(false)
      package
    end

    expect {
      Evm::Command::Uninstall.new(['foo'])
    }.to raise_error('Not installed foo')
  end

  it 'should raise exception if no package name' do
    expect {
      Evm::Command::Uninstall.new([])
    }.to raise_error('The uninstall command requires an argument')
  end
end
