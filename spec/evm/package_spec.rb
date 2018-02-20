require 'spec_helper'

describe Evm::Package do
  let :file_class do
    double('file_class')
  end

  let :file_instance do
    double('file_instance')
  end

  let :config do
    double('config')
  end

  before do
    @foo = Evm::Package.new('foo', file: file_class)
    allow(@foo).to receive(:name).and_return('foo')
    @foo
  end

  describe '#current?' do
    it 'should be current if current name is same as name' do
      allow(Evm::Package).to receive(:current).and_return(@foo)
      expect(Evm::Package.new('foo')).to be_current
    end

    it 'should not be current if current name is different from name' do
      allow(Evm::Package).to receive(:current).and_return(@foo)
      expect(Evm::Package.new('bar')).not_to be_current
    end

    it 'should not be current if no current' do
      allow(Evm::Package).to receive(:current)
      expect(Evm::Package.new('foo')).not_to be_current
    end
  end

  describe '#installed?' do
    it 'should be installed if path exists' do
      allow(file_class).to receive(:directory?).with(@foo.path).and_return(true)
      expect(@foo).to be_installed
    end

    it 'should not be installed if path does not exist' do
      allow(file_class).to receive(:directory?).with(@foo.path).and_return(false)
      expect(@foo).not_to be_installed
    end
  end

  describe '#path' do
    it 'should be path to package path' do
      expect(@foo.path).to eq('/tmp/evm/foo')
    end
  end

  describe '#bin' do
    it 'should be bin/emacs if linux' do
      allow(Evm::Os).to receive(:osx?).and_return(false)
      allow(Evm::Os).to receive(:linux?).and_return(true)
      allow(file_class).to receive(:exists?).with('/tmp/evm/foo/bin/emacs').and_return(true)
      expect(@foo.bin.to_s).to eq('/tmp/evm/foo/bin/emacs')
    end

    it 'should be bin/emacs if osx and no nextstep' do
      allow(Evm::Os).to receive(:osx?).and_return(true)
      allow(Evm::Os).to receive(:linux?).and_return(false)

      allow(file_class).to receive(:exists?).with('/tmp/evm/foo/Emacs.app').and_return(false)
      allow(file_class).to receive(:exists?).with('/tmp/evm/foo/bin/emacs').and_return(true)

      expect(@foo.bin.to_s).to eq('/tmp/evm/foo/bin/emacs')
    end

    it 'should be nextstep bin if osx and nextstep' do
      allow(Evm::Os).to receive(:osx?).and_return(true)
      allow(Evm::Os).to receive(:linux?).and_return(false)

      allow(file_class).to receive(:exists?).with('/tmp/evm/foo/Emacs.app').and_return(true)

      expect(@foo.bin).to eq('/tmp/evm/foo/Emacs.app/Contents/MacOS/Emacs')
    end

    context 'remacs' do
      it 'returns bin/remacs if linux' do
        allow(Evm::Os).to receive(:osx?).and_return(false)
        allow(Evm::Os).to receive(:linux?).and_return(true)
        allow(file_class).to receive(:exists?).with('/tmp/evm/foo/bin/emacs').and_return(false)
        allow(file_class).to receive(:exists?).with('/tmp/evm/foo/bin/remacs').and_return(true)
        expect(@foo.bin.to_s).to eq('/tmp/evm/foo/bin/remacs')
      end
    end
  end

  describe '#use!' do
    it 'creates emacs and evm-emacs shims' do
      expect(file_class).to receive(:exists?).with(Evm::EMACS_PATH).and_return(false)
      allow(file_class).to receive(:exists?).with('/tmp/evm/foo/Emacs.app').and_return(false)
      allow(file_class).to receive(:exists?).with('/tmp/evm/foo/bin/emacs').and_return(true)
      expect(file_class).to receive(:exists?).with(Evm::EVM_EMACS_PATH).and_return(true)
      expect(file_class).to receive(:delete).with(Evm::EVM_EMACS_PATH)
      expect(file_class).to receive(:open).twice.with(anything, 'w').and_yield(file_instance)
      expect(file_class).to receive(:chmod).twice
      expect(file_instance).to receive(:puts).twice.with("#!/bin/bash\nexec \"/tmp/evm/foo/bin/emacs\" \"$@\"")

      @foo.use!
    end

    it 'sets current package' do
      allow(file_class).to receive(:exists?)
      allow(file_class).to receive(:open)
      allow(file_class).to receive(:chmod)
      allow(file_instance).to receive(:puts)
      allow(Evm).to receive(:config).and_return(config)
      expect(config).to receive(:[]=).with(:current, 'foo')

      @foo.use!
    end
  end

  describe '#disuse!' do
    it 'removes emacs and evm-emacs shims' do
      expect(file_class).to receive(:exists?).with(Evm::EMACS_PATH).and_return(true)
      expect(file_class).to receive(:exists?).with(Evm::EVM_EMACS_PATH).and_return(true)
      expect(file_class).to receive(:delete).with(Evm::EMACS_PATH)
      expect(file_class).to receive(:delete).with(Evm::EVM_EMACS_PATH)

      @foo.disuse!
    end

    it 'unsets current package' do
      allow(file_class).to receive(:exists?)
      allow(Evm).to receive(:config).and_return(config)
      expect(config).to receive(:[]=).with(:current, nil)

      @foo.disuse!
    end
  end

  describe '#install!' do
    before do
      @builder = double('builder')

      allow(file_class).to receive(:directory?).with('/tmp/evm/foo').and_return(true)
      allow(Evm::Builder).to receive(:new).and_return(@builder)
    end

    it 'should create installation path if not exist' do
      allow(file_class).to receive(:directory?).with('/tmp/evm/foo').and_return(false)

      expect(Dir).to receive(:mkdir).with('/tmp/evm/foo')
      expect(@builder).to receive(:build!)

      @foo.install!
    end

    it 'should not create installation path if exists' do
      allow(file_class).to receive(:directory?).with('/tmp/evm/foo').and_return(true)

      expect(Dir).not_to receive(:mkdir)
      expect(@builder).to receive(:build!)

      @foo.install!
    end

    it 'should clean up if directory creation fails' do
      allow(file_class).to receive(:directory?).with('/tmp/evm/foo').and_return(false)

      expect(FileUtils).to receive(:mkdir_p).with('/tmp/evm/foo').and_raise(Errno::EACCES)
      expect(@builder).not_to receive(:build!)
      expect(@foo).to receive(:uninstall!)

      expect{@foo.install!}.to raise_exception(Errno::EACCES)
    end

    it 'should clean up if installation fails' do
      allow(file_class).to receive(:directory?).with('/tmp/evm/foo').and_return(true)

      expect(@builder).to receive(:build!).and_raise('build failure')
      expect(@foo).to receive(:uninstall!)

      expect{@foo.install!}.to raise_exception('build failure')
    end
  end

  describe '#uninstall!' do
    before do
      allow(@foo).to receive(:current?).and_return(false)
    end

    it 'should remove installation path if exists' do
      allow(file_class).to receive(:directory?).and_return(true)
      expect(FileUtils).to receive(:rm_r).with('/tmp/evm/foo')

      @foo.uninstall!
    end

    it 'should not remove installation path if not exists' do
      allow(file_class).to receive(:directory?).and_return(false)
      expect(FileUtils).not_to receive(:rm_r)

      @foo.uninstall!
    end

    it 'should remove shims and unset current if current' do
      allow(file_class).to receive(:directory?).and_return(true)
      allow(@foo).to receive(:current?).and_return(true)
      allow(config).to receive(:[]).with(:path).and_return('/tmp/evm')
      allow(Evm).to receive(:config).and_return(config)

      expect(FileUtils).to receive(:rm_r).with('/tmp/evm/foo')
      expect(file_class).to receive(:exists?).with(Evm::EMACS_PATH).and_return(true)
      expect(file_class).to receive(:exists?).with(Evm::EVM_EMACS_PATH).and_return(true)
      expect(file_class).to receive(:delete).with(Evm::EVM_EMACS_PATH)
      expect(file_class).to receive(:delete).with(Evm::EMACS_PATH)
      expect(config).to receive(:[]=).with(:current, nil)

      @foo.uninstall!
    end

    it 'should not remove shims or unset current if not current' do
      allow(file_class).to receive(:directory?).and_return(false)
      allow(config).to receive(:[]).with(:path).and_return('/tmp/evm')
      allow(Evm).to receive(:config).and_return(config)

      expect(file_class).not_to receive(:delete).with(Evm::EVM_EMACS_PATH)
      expect(file_class).not_to receive(:delete).with(Evm::EMACS_PATH)
      expect(config).not_to receive(:[]=)

      @foo.uninstall!
    end
  end

  describe '#to_s' do
    it 'should return name' do
      expect(@foo.to_s).to eq('foo')
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
      allow(Evm::Recipe).to receive(:find).and_return({})

      expect(Evm::Package.find('foo').name).to eq('foo')
    end

    it 'should raise exception if no recipe with same name' do
      allow(Evm::Recipe).to receive(:find).and_return(nil)
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

      allow(Evm::Recipe).to receive(:all).and_return(recipes)

      package_1, package_2 = Evm::Package.all

      expect(package_1.name).to eq('foo')
      expect(package_2.name).to eq('bar')
    end
  end
end
