require 'spec_helper'

describe Evm::RemoteFile do
  before do
    @tempfile = Tempfile.new('remote-file').path

    @path = Pathname.new(@tempfile)
    @path.stub(:exist?).and_return(true)

    @url = 'http://domain.com/emacs-24.3.tar.gz'

    stub_request(:get, @url).
      to_return(:status => 200, :body => 'COMPRESSED-DATA', :headers => { 'Content-Length' => 1234 })

    @remote_file = Evm::RemoteFile.new(@url)
  end

  describe '#download' do
    it 'should download to path' do
      @path.stub(:exist?).and_return(false)

      @remote_file.download(@path)

      File.read(@tempfile).should == 'COMPRESSED-DATA'
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
