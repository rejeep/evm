require 'spec_helper'

describe Evm::Command::List do
  it 'should print list of packages' do
    Evm::Package.stub(:all) do
      foo = double('foo')
      foo.stub(:current?).and_return(true)
      foo.stub(:installed?).and_return(true)
      foo.stub(:to_s).and_return('foo')

      bar = double('bar')
      bar.stub(:current?).and_return(false)
      bar.stub(:installed?).and_return(false)
      bar.stub(:to_s).and_return('bar')

      baz = double('baz')
      baz.stub(:current?).and_return(false)
      baz.stub(:installed?).and_return(true)
      baz.stub(:to_s).and_return('baz')

      [foo, bar, baz]
    end

    output = []
    STDOUT.stub(:puts) { |*args|
      output << args.first.to_s + "\n"
    }
    STDOUT.stub(:print) { |*args|
      output << args.first.to_s
    }

    Evm::Command::List.new()

    output.join.should == "* foo [I]\nbar\nbaz [I]\n"
  end
end
