require 'spec_helper'

describe Evm::TarFile do
  let('tar_file') { '/path/to/foo.tar.gz' }

  subject do
    Evm::TarFile.new(@tar_file)
  end

  describe '#extract' do
    it 'extracts tar file to path when no name' do
      subject.should_receive(:tar).with('-xzf', @tar_file, '-C', '/path/to')
      subject.extract('/path/to')
    end

    it 'extracts tar file to path/name when name' do
      subject.should_receive(:tar).with('-xzf', @tar_file, '-C', '/path/to/directory', '--strip-components', '1')
      subject.extract('/path/to', 'directory')
    end
  end
end
