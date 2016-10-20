require 'spec_helper'

describe Evm::Command::Use do
  it 'should use package name if installed' do
    allow(Evm::Package).to receive(:find) do |package_name|
      package = double('package')
      allow(package).to receive(:installed?).and_return(true)
      expect(package).to receive(:use!)
      package
    end

    Evm::Command::Use.new(['foo'])
  end

  it 'should raise exception if package is not installed' do
    allow(Evm::Package).to receive(:find) do |package_name|
      package = double('package')
      allow(package).to receive(:installed?).and_return(false)
      package
    end

    expect {
      Evm::Command::Use.new(['foo'])
    }.to raise_error('Package not installed: foo')
  end

  it 'should raise exception if no package name' do
    expect {
      Evm::Command::Use.new([])
    }.to raise_error('The use command requires an argument')
  end
end
