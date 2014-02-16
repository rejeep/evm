require 'spec_helper'

describe Evm::Command::Install do
  it 'should install if package and not installed' do
    Evm::Package.stub(:find) do |package_name|
      package = double('package')
      package.should_receive(:install!)
      package.stub(:installed?).and_return(false)
      package
    end

    STDOUT.should_receive(:puts).with('Successfully installed foo')

    Evm::Command::Install.new('foo')
  end

  it 'should uninstall first if force option' do
    Evm::Package.stub(:find) do |package_name|
      package = double('package')
      package.should_receive(:install!)
      package.should_receive(:uninstall!)
      package.stub(:installed?).and_return(false)
      package
    end

    STDOUT.should_receive(:puts).with('Successfully installed foo')

    Evm::Command::Install.new('foo', :force => true)
  end

  it 'should install when installed if force' do
    Evm::Package.stub(:find) do |package_name|
      package = double('package')
      package.should_receive(:install!)
      package.stub(:uninstall!) {
        package.stub(:installed?).and_return(false)
      }
      package.stub(:installed?).and_return(true)
      package
    end

    STDOUT.should_receive(:puts).with('Successfully installed foo')

    Evm::Command::Install.new('foo', :force => true)
  end

  it 'should install and use if --use option' do
    Evm::Package.stub(:find) do |package_name|
      package = double('package')
      package.should_receive(:use!)
      package.should_receive(:install!)
      package.stub(:installed?).and_return(false)
      package
    end

    STDOUT.should_receive(:puts).with('Successfully installed foo')

    Evm::Command::Install.new('foo', :use => true)
  end

  it 'should raise exception if already installed' do
    Evm::Package.stub(:find) do |package_name|
      package = double('package')
      package.should_not_receive(:install!)
      package.stub(:installed?).and_return(true)
      package
    end

    expect {
      Evm::Command::Install.new('foo')
    }.to raise_error('Already installed foo')
  end

  it 'should raise exception if no package name' do
    expect {
      Evm::Command::Install.new(nil)
    }.to raise_error('The install command requires an argument')
  end

  it 'should not install if already installed and --skip option' do
    Evm::Package.stub(:find) do |package_name|
      package = double('package')
      package.should_not_receive(:install!)
      package.stub(:installed?).and_return(true)
      package
    end

    Evm::Command::Install.new('foo', :skip => true)
  end

  it 'should install if not already installed and --skip option' do
    Evm::Package.stub(:find) do |package_name|
      package = double('package')
      package.should_receive(:install!)
      package.stub(:installed?).and_return(false)
      package
    end

    STDOUT.should_receive(:puts).with('Successfully installed foo')

    Evm::Command::Install.new('foo', :skip => true)
  end
end
