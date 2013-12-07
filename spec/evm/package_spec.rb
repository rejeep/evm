require 'spec_helper'

require 'tempfile'

describe Evm::Package do
  let(:foo) do
    foo = Evm::Package.new('foo')
    foo.stub(:name).and_return('foo')
    foo
  end

  describe '#current?' do
    it 'should be current if current name is same as name' do
      Evm::Package.stub(:current).and_return(foo)
      Evm::Package.new('foo').should be_current
    end

    it 'should not be current if current name is different from name' do
      Evm::Package.stub(:current).and_return(foo)
      Evm::Package.new('bar').should_not be_current
    end

    it 'should not be current if no current' do
      Evm::Package.stub(:current)
      Evm::Package.new('foo').should_not be_current
    end
  end

  describe '#installed?' do
    it 'should be installed if path exists' do
      foo.stub(:path) do
        path = double('path')
        path.stub(:exist?).and_return(true)
        path
      end
      foo.should be_installed
    end

    it 'should not be installed if path does not exist' do
      foo.stub(:path) do
        path = double('path')
        path.stub(:exist?).and_return(false)
        path
      end
      foo.should_not be_installed
    end
  end

  describe '#path' do
    it 'should be path to package path' do
      foo.path.to_s.should == '/usr/local/evm/foo'
    end
  end

  describe '#bin' do
    it 'should be bin/emacs if linux' do
      Evm::Os.stub(:osx?).and_return(false)
      Evm::Os.stub(:linux?).and_return(true)

      foo.bin.to_s.should == '/usr/local/evm/foo/bin/emacs'
    end

    it 'should be bin/emacs if osx and no nextstep' do
      Evm::Os.stub(:osx?).and_return(true)
      Evm::Os.stub(:linux?).and_return(false)

      join = double('join')
      join.stub(:exist?).and_return(false)

      path = double('path')
      path.should_receive(:join).with('Emacs.app').and_return(join)
      path.should_receive(:join).with('bin', 'emacs').and_return('/usr/local/evm/foo/bin/emacs')

      foo.stub(:path).and_return(path)

      foo.bin.to_s.should == '/usr/local/evm/foo/bin/emacs'
    end

    it 'should be nextstep bin if osx and nextstep' do
      Evm::Os.stub(:osx?).and_return(true)
      Evm::Os.stub(:linux?).and_return(false)

      join = double('join')
      join.stub(:exist?).and_return(true)

      path = double('path')
      path.should_receive(:join).with('Emacs.app').and_return(join)
      path.should_receive(:join).with('Emacs.app', 'Contents', 'MacOS', 'Emacs').and_return('/usr/local/evm/foo/Emacs.app/Contents/MacOS/Emacs')

      foo.stub(:path).and_return(path)

      foo.bin.to_s.should == '/usr/local/evm/foo/Emacs.app/Contents/MacOS/Emacs'
    end
  end

  describe '#use!' do
    it 'should write name to current file' do
      tempfile = Tempfile.new('foo')

      Evm::Package.stub(:current_file).and_return(tempfile.to_s)

      foo.use!

      File.read(tempfile.to_s).should == 'foo'
    end
  end

  describe '#install!' do
    before do
      @path = double('path')
      @path.stub(:exist?).and_return(true)

      @builder = double('builder')
      @builder.should_receive(:build!)

      Evm::Builder.stub(:new).and_return(@builder)

      foo.stub(:path).and_return(@path)
    end

    it 'should create installation path if not exist' do
      @path.should_receive(:mkdir)
      @path.stub(:exist?).and_return(false)

      foo.install!
    end

    it 'should not create installation path if exists' do
      @path.should_not_receive(:mkdir)
      @path.stub(:exist?).and_return(true)

      foo.install!
    end

    it 'should create tmp path if not exist' do
      tmp_path = double('tmp_file')
      tmp_path.should_receive(:mkdir)
      tmp_path.stub(:exist?).and_return(false)

      foo.stub(:tmp_path).and_return(tmp_path)

      foo.install!
    end

    it 'should not create installation path if exists' do
      tmp_path = double('tmp_file')
      tmp_path.should_not_receive(:mkdir)
      tmp_path.stub(:exist?).and_return(true)

      foo.stub(:tmp_path).and_return(tmp_path)

      foo.install!
    end
  end

  describe '#uninstall!' do
    before do
      @path = double('path')
      @path.stub(:exist?).and_return(false)

      foo.stub(:path).and_return(@path)
    end

    it 'should remove installation path if exists' do
      @path.should_receive(:rmtree)
      @path.stub(:exist?).and_return(true)

      foo.stub(:current?).and_return(false)
      foo.uninstall!
    end

    it 'should not remove installation path if not exists' do
      @path.should_not_receive(:rmtree)
      @path.stub(:exist?).and_return(false)

      foo.stub(:current?).and_return(false)
      foo.uninstall!
    end

    it 'should remove current file if current' do
      foo.stub(:current?).and_return(true)

      current_file = double('current_file')
      current_file.should_receive(:delete)

      Evm::Package.should_receive(:current_file).and_return(current_file)

      foo.uninstall!
    end
  end

  describe '#to_s' do
    it 'should return name' do
      foo.to_s.should == 'foo'
    end
  end

  describe '.current_file' do
    it 'should be path to current file' do
      Evm::Package.current_file.to_s.should == '/usr/local/evm/current'
    end
  end

  describe '.current' do
    it 'should find current' do
      current_file = double('current_file')
      current_file.stub(:exist?).and_return(true)
      current_file.stub(:read).and_return('foo')

      Evm::Package.stub(:current_file).and_return(current_file)
      Evm::Package.should_receive(:find).with('foo')
      Evm::Package.current
    end

    it 'should be nil if no current file' do
      current_file = double('current_file')
      current_file.stub(:exist?).and_return(false)

      Evm::Package.stub(:current_file).and_return(current_file)
      Evm::Package.current.should be_nil
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
