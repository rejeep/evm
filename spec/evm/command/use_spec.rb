require 'spec_helper'

describe Evm::Command::Use do
  it 'should use package name if installed' do
    Evm::Package.stub(:find) do |package_name|
      package = double('package')
      package.stub(:installed?).and_return(true)
      package.should_receive(:use!)
      package
    end

    Evm::Command::Use.new('foo')
  end

  it 'should raise exception if package is not installed' do
    Evm::Package.stub(:find) do |package_name|
      package = double('package')
      package.stub(:installed?).and_return(false)
      package
    end

    expect {
      Evm::Command::Use.new('foo')
    }.to raise_error('Package not installed: foo')
  end

  it 'should raise exception if no package name' do
    expect {
      Evm::Command::Use.new(nil)
    }.to raise_error('The use command requires an argument')
  end
end
