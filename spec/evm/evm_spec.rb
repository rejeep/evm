require 'spec_helper'

describe Evm do
  it 'should return correct root directory' do
    Evm::ROOT_PATH.should == File.expand_path('../..', File.dirname(__FILE__))
  end

  it 'should return correct local directory' do
    Evm::LOCAL_PATH.should == '/usr/local/evm'
  end
end
