require 'spec_helper'

describe Evm::RemoteFile do
  before do
    @path = Pathname.new('/path/to/emacs-24.3.tar.gz')
    @path.stub(:exist?).and_return(true)

    @url = 'http://domain.com/emacs-24.3.tar.gz'

    @file = double('file')
    @file.stub(:close)

    File.stub(:open).and_return(@file)

    stub_request(:get, @url).
      to_return(:status => 200, :body => 'COMPRESSED-DATA', :headers => { 'Content-Length' => 1234 })

    @remote_file = Evm::RemoteFile.new(@url)
  end

  describe '#download' do
    it 'should download to path' do
      @path.stub(:exist?).and_return(false)

      @file.should_receive(:write).with('COMPRESSED-DATA')

      @remote_file.download(@path)
    end

    it 'should close file' do
      @path.stub(:exist?).and_return(false)

      file = double('file')
      file.should_receive(:close)
      file.stub(:write)

      File.stub(:open).and_return(file)

      @remote_file.download(@path)
    end

    it 'should not download if already exist' do
      @path.stub(:exist?).and_return(true)

      @remote_file.download(@path)
    end
  end
end
