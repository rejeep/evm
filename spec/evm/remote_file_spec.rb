require 'spec_helper'

describe Evm::RemoteFile do
  let :url do
    'http://mirror.com/emacs-24.3.tar.gz'
  end

  let :path do
    '/path/to/emacs-24.3.tar.gz'
  end

  let :file_class do
    double('file_class')
  end

  let :file_instance do
    double('file_instance')
  end

  let :uri do
    double('uri')
  end

  let :data do
    'DATA'
  end

  subject do
    Evm::RemoteFile.new(url, file: file_class, uri: uri)
  end

  describe '#download' do
    it 'downloads file to path' do
      expect(file_class).to receive(:exist?).with(path).and_return(false)
      expect(file_class).to receive(:open).with(path, 'w').and_yield(file_instance)
      expect(file_instance).to receive(:write).with(data)
      expect(uri).to receive_message_chain(:parse, :read).and_return(data)
      subject.download(path)
    end

    it 'does not download file if file already exist' do
      expect(file_class).to receive(:exist?).with(path).and_return(true)
      expect(file_class).to_not receive(:open)
      subject.download(path)
    end
  end
end
