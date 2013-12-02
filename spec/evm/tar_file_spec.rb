require 'spec_helper'

describe Evm::TarFile do
  before do
    @tar_file = Evm::TarFile.new('foo.tar.gz')

    @system = double('system')
    @system.stub(:run)

    Evm::System.stub(:new).and_return(@system)
  end

  describe '#download!' do
    before do
      @remote_file = double('remote_file')

      @progress_bar = double('progress_bar')
      @progress_bar.stub(:set)
      @progress_bar.stub(:done)

      @tars_path = double('tars_path')
      @tar_path = double('tar_path')

      @tar_file.stub(:tars_path).and_return(@tars_path)
      @tar_file.stub(:tar_path).and_return(@tar_path)
      @tar_file.stub(:progress_bar).and_return(@progress_bar)
      @tar_file.stub(:remote_file).and_return(@remote_file)
    end

    it 'should create tars path if it does not exist' do
      @tar_path.stub(:exist?).and_return(true)
      @tars_path.should_receive(:mkdir)
      @tars_path.stub(:exist?).and_return(false)

      @tar_file.download!
    end

    it 'should not create tars path if it does not exist' do
      @tar_path.stub(:exist?).and_return(true)
      @tars_path.should_not_receive(:mkdir)
      @tars_path.stub(:exist?).and_return(true)

      @tar_file.download!
    end

    it 'should not download tar if already exists' do
      @tar_path.stub(:exist?).and_return(true)
      @tars_path.stub(:exist?).and_return(true)

      @remote_file.should_not_receive(:save_to)

      @tar_file.download!
    end

    it 'should download tar file and save if not already exists' do
      stub_request(:get, 'https://s3.amazonaws.com/emacs-evm/foo.tar.gz').
        to_return(:status => 200, :body => 'COMPRESSED-DATA')

      @tar_path.stub(:exist?).and_return(false)
      @tars_path.stub(:exist?).and_return(true)

      @remote_file.should_receive(:save_to).with(@tar_path)

      @tar_file.download!
    end

    it 'should update progress bar for each progress' do
      @tar_path.stub(:exist?).and_return(false)
      @tars_path.stub(:exist?).and_return(true)

      @progress_bar.should_receive(:set).with(0).once
      @progress_bar.should_receive(:set).with(50).once
      @progress_bar.should_receive(:set).with(100).once

      @remote_file.stub(:save_to) do |tar_file, &block|
        block.call(0)
        block.call(50)
        block.call(100)
      end

      @tar_file.download!
    end

    it 'should done progress bar when done' do
      @tar_path.stub(:exist?).and_return(false)
      @tars_path.stub(:exist?).and_return(true)

      @progress_bar.should_receive(:done)

      @remote_file.stub(:save_to)

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
