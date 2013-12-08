require 'spec_helper'

describe Evm::Git do
  before do
    @path = '/path/to/git'

    @git = Evm::Git.new(@path)
  end

  describe 'exist?' do
    it 'should exist when path does exist' do
      File.stub(:exist?).and_return(false)

      @git.exist?.should == false
    end

    it 'should not exist when path does not exist' do
      File.stub(:exist?).and_return(true)

      @git.exist?.should == true
    end
  end

  describe 'clone' do
    it 'should clone url to path' do
      @git.should_receive(:git).with('clone', 'URL', @path)
      @git.clone('URL')
    end
  end

  describe 'pull' do
    it 'should pull in path' do
      Dir.should_receive(:chdir).with(@path).and_yield

      @git.should_receive(:git).with('pull')
      @git.pull
    end
  end
end
