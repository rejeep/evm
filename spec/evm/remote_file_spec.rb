require 'spec_helper'

describe Evm::RemoteFile do
  before do
    @path = '/path/to/emacs-24.3.tar.gz'

    @url = 'http://mirror.com/emacs-24.3.tar.gz'

    @file = double('file')
    @file.stub(:close)

    File.stub(:exist?).with(@path).and_return(false)
    File.stub(:open).and_return(@file)

    @remote_file = Evm::RemoteFile.new(@url)
  end

  describe '#download' do
    it 'should download to path' do
      stub_request(:get, @url).
        to_return(:status => 200, :body => 'COMPRESSED-DATA', :headers => { 'Content-Length' => 1234 })


      @file.should_receive(:write).with('COMPRESSED-DATA')

      @remote_file.download(@path)
    end

    it 'should download to path' do
      stub_request(:get, @url).
        to_return(:status => 302, :headers => { 'location' => @url }).then.
        to_return(:status => 200, :body => 'COMPRESSED-DATA', :headers => { 'Content-Length' => 1234 })

      @file.should_receive(:write).with('COMPRESSED-DATA')

      @remote_file.download(@path)
    end

    it 'should close file' do
      stub_request(:get, @url).
        to_return(:status => 200, :body => 'COMPRESSED-DATA', :headers => { 'Content-Length' => 1234 })

      file = double('file')
      file.should_receive(:close)
      file.stub(:write)

      File.stub(:open).and_return(file)

      @remote_file.download(@path)
    end

    it 'should not download if already exist' do
      File.stub(:exist?).with(@path).and_return(true)

      @remote_file.download(@path)
    end
  end
end
