require 'spec_helper'

describe Evm::Command::Install do
  it 'should install if package and not installed' do
    allow(Evm::Package).to receive(:find) do |package_name|
      package = double('package')
      expect(package).to receive(:install!)
      allow(package).to receive(:installed?).and_return(false)
      package
    end

    expect(STDOUT).to receive(:puts).with('Successfully installed foo')

    Evm::Command::Install.new(['foo'])
  end

  it 'should uninstall first if force option' do
    allow(Evm::Package).to receive(:find) do |package_name|
      package = double('package')
      expect(package).to receive(:install!)
      expect(package).to receive(:uninstall!)
      allow(package).to receive(:installed?).and_return(false)
      package
    end

    expect(STDOUT).to receive(:puts).with('Successfully installed foo')

    Evm::Command::Install.new(['foo'], :force => true)
  end

  it 'should install when installed if force' do
    allow(Evm::Package).to receive(:find) do |package_name|
      package = double('package')
      expect(package).to receive(:install!)
      allow(package).to receive(:uninstall!) {
        allow(package).to receive(:installed?).and_return(false)
      }
      allow(package).to receive(:installed?).and_return(true)
      package
    end

    expect(STDOUT).to receive(:puts).with('Successfully installed foo')

    Evm::Command::Install.new(['foo'], :force => true)
  end

  it 'should install and use if --use option' do
    allow(Evm::Package).to receive(:find) do |package_name|
      package = double('package')
      expect(package).to receive(:use!)
      expect(package).to receive(:install!)
      allow(package).to receive(:installed?).and_return(false)
      package
    end

    expect(STDOUT).to receive(:puts).with('Successfully installed foo')

    Evm::Command::Install.new(['foo'], :use => true)
  end

  it 'should raise exception if already installed' do
    allow(Evm::Package).to receive(:find) do |package_name|
      package = double('package')
      expect(package).not_to receive(:install!)
      allow(package).to receive(:installed?).and_return(true)
      package
    end

    expect {
      Evm::Command::Install.new(['foo'])
    }.to raise_error('Already installed foo')
  end

  it 'should raise exception if no package name' do
    expect {
      Evm::Command::Install.new([nil])
    }.to raise_error('The install command requires an argument')
  end

  it 'should not install if already installed and --skip option' do
    allow(Evm::Package).to receive(:find) do |package_name|
      package = double('package')
      expect(package).not_to receive(:install!)
      allow(package).to receive(:installed?).and_return(true)
      package
    end

    Evm::Command::Install.new(['foo'], :skip => true)
  end

  it 'should install if not already installed and --skip option' do
    allow(Evm::Package).to receive(:find) do |package_name|
      package = double('package')
      expect(package).to receive(:install!)
      allow(package).to receive(:installed?).and_return(false)
      package
    end

    expect(STDOUT).to receive(:puts).with('Successfully installed foo')

    Evm::Command::Install.new(['foo'], :skip => true)
  end
end
