require 'spec_helper'

describe Evm::Command::Use do
  it 'should use package name' do
    Evm::Package.stub(:find) do |package_name|
      package_name.should == 'foo'

      package = double('package')
      package.should_receive(:use!)
      package
    end

    Evm::Command::Use.new('foo')
  end
end
