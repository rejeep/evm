require 'spec_helper'

describe Evm::Git do
  before do
    @path = '/path/to/git'

    @git = Evm::Git.new(@path)
  end

  describe 'exist?' do
    it 'should exist when path does exist' do
      allow(File).to receive(:exist?).and_return(false)

      expect(@git.exist?).to be false
    end

    it 'should not exist when path does not exist' do
      allow(File).to receive(:exist?).and_return(true)

      expect(@git.exist?).to be true
    end
  end

  describe 'clone' do
    it 'should clone url to path' do
      expect(@git).to receive(:git).with('clone', 'URL', @path)
      @git.clone('URL')
    end
  end

  describe 'pull' do
    it 'should pull in path' do
      expect(Dir).to receive(:chdir).with(@path).and_yield

      expect(@git).to receive(:git).with('pull')
      @git.pull
    end
  end
end
