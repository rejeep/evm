require 'spec_helper'

describe Evm::Command::Uninstall do
  it 'should uninstall if installed' do
    allow(Evm::Package).to receive(:find) do |package_name|
      package = double('package')
      expect(package).to receive((:uninstall!))
      allow(package).to receive(:installed?).and_return(true)
      package
    end

    expect(STDOUT).to receive(:puts).with('Successfully uninstalled foo')

    Evm::Command::Uninstall.new(['foo'])
  end

  it 'should raise exception if not installed' do
    allow(Evm::Package).to receive(:find) do |package_name|
      package = double('package')
      expect(package).not_to receive(:uninstall!)
      allow(package).to receive(:installed?).and_return(false)
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
