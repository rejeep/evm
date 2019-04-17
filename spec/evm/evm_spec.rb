require 'spec_helper'

describe Evm do
  it 'should return correct root directory' do
    expect(Evm::ROOT_PATH).to eq(File.expand_path('../..', File.dirname(__FILE__)))
  end

  it 'should return correct local directory' do
    expect(Evm::LOCAL_PATH).to eq('/usr/local/evm')
  end
end
