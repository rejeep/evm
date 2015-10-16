require 'spec_helper'

describe Evm::Package do
  let :file_class do
    double('file_class')
  end

  let :file_instance do
    double('file_instance')
  end

  before do
    @foo = Evm::Package.new('foo', file: file_class)
    @foo.stub(:name).and_return('foo')
    @foo
  end

  describe '#current?' do
    it 'should be current if current name is same as name' do
      Evm::Package.stub(:current).and_return(@foo)
      Evm::Package.new('foo').should be_current
    end

    it 'should not be current if current name is different from name' do
      Evm::Package.stub(:current).and_return(@foo)
      Evm::Package.new('bar').should_not be_current
    end

    it 'should not be current if no current' do
      Evm::Package.stub(:current)
      Evm::Package.new('foo').should_not be_current
    end
  end

  describe '#installed?' do
    before do
      @binary = '/tmp/evm/foo/bin/emacs'
    end

    it 'should be installed if binary exists' do
      @foo.stub(:bin).and_return(@binary)

      File.should_receive(:file?).with(@binary).and_return(true)
      File.should_receive(:executable?).with(@binary).and_return(true)

      @foo.should be_installed
    end

    it 'should not be installed if binary does not exist' do
      @foo.stub(:bin).and_return(@binary)

      File.should_receive(:file?).with(@binary).and_return(false)

      @foo.should_not be_installed
    end

    it 'should not be installed if binary exists, but is not binary' do
      @foo.stub(:bin).and_return(@binary)

      File.should_receive(:file?).with(@binary).and_return(true)
      File.should_receive(:executable?).with(@binary).and_return(false)

      @foo.should_not be_installed
    end
  end

  describe '#path' do
    it 'should be path to package path' do
      @foo.path.should == '/tmp/evm/foo'
    end
  end

  describe '#bin' do
    it 'should be bin/emacs if linux' do
      Evm::Os.stub(:osx?).and_return(false)
      Evm::Os.stub(:linux?).and_return(true)

      @foo.bin.to_s.should == '/tmp/evm/foo/bin/emacs'
    end

    it 'should be bin/emacs if osx and no nextstep' do
      Evm::Os.stub(:osx?).and_return(true)
      Evm::Os.stub(:linux?).and_return(false)

      File.stub(:exist?).with('/tmp/evm/foo/Emacs.app').and_return(false)

      @foo.bin.to_s.should == '/tmp/evm/foo/bin/emacs'
    end

    it 'should be nextstep bin if osx and nextstep' do
      Evm::Os.stub(:osx?).and_return(true)
      Evm::Os.stub(:linux?).and_return(false)

      File.stub(:exist?).with('/tmp/evm/foo/Emacs.app').and_return(true)

      @foo.bin.should == '/tmp/evm/foo/Emacs.app/Contents/MacOS/Emacs'
    end
  end

  describe '#use!' do
    it 'creates emacs and evm-emacs shims' do
      expect(file_class).to receive(:exists?).with(Evm::EMACS_PATH).and_return(false)
      expect(file_class).to receive(:exists?).with(Evm::EVM_EMACS_PATH).and_return(true)
      expect(file_class).to receive(:delete).with(Evm::EVM_EMACS_PATH)
      expect(file_class).to receive(:open).twice.with(anything, 'w').and_yield(file_instance)
      expect(file_class).to receive(:chmod).twice
      expect(file_instance).to receive(:puts).twice.with("#!/bin/bash\nexec \"/tmp/evm/foo/bin/emacs\" \"$@\"")

      @foo.use!
    end
  end

  describe '#install!' do
    before do
      @builder = double('builder')
      @builder.should_receive(:build!)

      File.stub(:exist?).with('/tmp/evm/foo').and_return(true)
      File.stub(:exist?).with('/tmp/evm/tmp').and_return(true)

      Evm::Builder.stub(:new).and_return(@builder)
    end

    it 'should create installation path if not exist' do
      File.stub(:exist?).with('/tmp/evm/foo').and_return(false)

      Dir.should_receive(:mkdir).with('/tmp/evm/foo')

      @foo.install!
    end

    it 'should not create installation path if exists' do
      File.stub(:exist?).with('/tmp/evm/foo').and_return(true)

      Dir.should_not_receive(:mkdir)

      @foo.install!
    end

    it 'should create tmp path if not exist' do
      File.stub(:exist?).with('/tmp/evm/tmp').and_return(false)

      Dir.should_receive(:mkdir).with('/tmp/evm/tmp')

      @foo.install!
    end

    it 'should not create installation path if exists' do
      File.stub(:exist?).with('/tmp/evm/tmp').and_return(true)

      Dir.should_not_receive(:mkdir).with('/tmp/evm/tmp')

      @foo.install!
    end
  end

  describe '#uninstall!' do
    before do
      @foo.stub(:current?).and_return(false)
    end

    it 'should remove installation path if exists' do
      File.stub(:exist?).and_return(true)
      FileUtils.should_receive(:rm_r).with('/tmp/evm/foo')

      @foo.uninstall!
    end

    it 'should not remove installation path if not exists' do
      File.stub(:exist?).and_return(false)
      FileUtils.should_not_receive(:rm_r)

      @foo.uninstall!
    end

    it 'should remove binary symlink if current' do
      FileUtils.should_receive(:rm).with(Evm::EVM_EMACS_PATH)

      @foo.stub(:current?).and_return(true)

      @foo.uninstall!
    end

    it 'should not remove binary symlink file if not current' do
      FileUtils.should_not_receive(:rm).with(Evm::EVM_EMACS_PATH)

      @foo.stub(:current?).and_return(false)

      @foo.uninstall!
    end
  end

  describe '#to_s' do
    it 'should return name' do
      @foo.to_s.should == 'foo'
    end
  end

  describe '.current' do
    it 'return package when set in config' do
      Evm.config[:current] = 'emacs-24.5'
      expect(Evm::Package.current.name).to eq('emacs-24.5')
    end

    it 'is nil unless set in config' do
      Evm.config[:current] = nil
      expect(Evm::Package.current).to be_nil
    end
  end

  describe '.find' do
    it 'should return recipe with same name' do
      Evm::Recipe.stub(:find).and_return({})

      Evm::Package.find('foo').name.should == 'foo'
    end

    it 'should raise exception if no recipe with same name' do
      Evm::Recipe.stub(:find).and_return(nil)
      expect {
        Evm::Package.find('baz')
      }.to raise_error('No such package: baz')
    end
  end

  describe '.all' do
    it 'should return array with one package for each recipe' do
      recipes = []
      recipes << double('recipe-1', :name => 'foo')
      recipes << double('recipe-2', :name => 'bar')

      Evm::Recipe.stub(:all).and_return(recipes)

      package_1, package_2 = Evm::Package.all

      package_1.name.should == 'foo'
      package_2.name.should == 'bar'
    end
  end
end
