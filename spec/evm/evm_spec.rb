require 'spec_helper'

describe Evm do
  it 'should return correct root directory' do
    Pathname.stub(:new) do
      grand = double('grand')
      grand.stub(:expand_path).and_return('PATH')

      parent = double('parent')
      parent.stub(:parent).and_return(grand)

      child = double('child')
      child.stub(:parent).and_return(parent)

      child
    end

    Evm.root.should == 'PATH'
  end

  it 'should return correct evm installation directory' do
    Evm.local.to_s.should == '/usr/local/evm'
  end
end
