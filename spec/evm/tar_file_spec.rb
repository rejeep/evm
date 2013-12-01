require 'spec_helper'

describe Evm::TarFile do
  before do
    @tar_file = Evm::TarFile.new('foo.tar.gz')

    @system = double('system')
    @system.stub(:run)

    Evm::System.stub(:new).and_return(@system)
  end

  describe '#download!' do
    it 'should create tars path if it does not exist' do
      tars_path = double('tars_path')
      tars_path.should_receive(:mkdir)
      tars_path.stub(:exist?).and_return(false)

      tar_path = double('tar_path')
      tar_path.stub(:exist?).and_return(true)

      @tar_file.stub(:tars_path).and_return(tars_path)
      @tar_file.stub(:tar_path).and_return(tar_path)
      @tar_file.download!
    end

    it 'should not create tars path if it does not exist' do
      tars_path = double('tars_path')
      tars_path.should_not_receive(:mkdir)
      tars_path.stub(:exist?).and_return(true)

      tar_path = double('tar_path')
      tar_path.stub(:exist?).and_return(true)

      @tar_file.stub(:tars_path).and_return(tars_path)
      @tar_file.stub(:tar_path).and_return(tar_path)
      @tar_file.download!
    end

    it 'should not download tar if already exists' do
      tars_path = double('tars_path')
      tars_path.stub(:exist?).and_return(true)

      tar_path = double('tar_path')
      tar_path.stub(:exist?).and_return(true)

      File.should_not_receive(:open)

      @tar_file.stub(:tars_path).and_return(tars_path)
      @tar_file.stub(:tar_path).and_return(tar_path)
      @tar_file.download!
    end

    it 'should download tar file and save if not already exists' do
      stub_request(:get, 'https://s3.amazonaws.com/emacs-evm/foo.tar.gz').
        to_return(:status => 200, :body => 'COMPRESSED-DATA')

      file = double('file')
      file.should_receive(:write).with('COMPRESSED-DATA')

      File.stub(:open).and_yield(file)

      tars_path = double('tars_path')
      tars_path.stub(:exist?).and_return(true)

      tar_path = double('tar_path')
      tar_path.stub(:exist?).and_return(false)

      @tar_file.stub(:tars_path).and_return(tars_path)
      @tar_file.stub(:tar_path).and_return(tar_path)
      @tar_file.download!
    end
  end

  describe '#extract!' do
    it 'should create builds directory unless exist' do
      builds_path = double('builds_path')
      builds_path.stub(:exist?).and_return(false)
      builds_path.should_receive(:mkdir)

      @tar_file.stub(:builds_path).and_return(builds_path)
      @tar_file.extract!
    end

    it 'should extract tar file in builds directory' do
      builds_path = double('builds_path')
      builds_path.stub(:to_s).and_return('/path/to/evm/tmp')
      builds_path.stub(:exist?).and_return(true)

      tar_path = double('tar_path')
      tar_path.stub(:to_s).and_return('/path/to/evm/tars/file.tar.gz')

      @system.should_receive(:run).with('-xzf', '/usr/local/evm/tars/foo.tar.gz', '-C', '/path/to/evm/tmp')

      @tar_file.stub(:builds_path).and_return(builds_path)
      @tar_file.extract!
    end
  end
end
