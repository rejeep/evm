require 'spec_helper'

describe Evm::TarFile do
  before do
    @path = '/path/to/foo.tar.gz'

    @tar_file = Evm::TarFile.new(@path)
  end

  describe '#extract' do
    it 'should extract tar file in path' do
      @tar_file.should_receive(:tar).with('-xzf', @path, '-C', '/path/to')
      @tar_file.extract('/path/to')
    end
  end
end
