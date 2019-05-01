require 'spec_helper'

describe Evm::Command::List do
  it 'should print sorted list of packages' do
    allow(Evm::Package).to receive(:all) do
      foo = double('foo')
      allow(foo).to receive(:current?).and_return(true)
      allow(foo).to receive(:installed?).and_return(true)
      allow(foo).to receive(:to_s).and_return('foo')

      bar = double('bar')
      allow(bar).to receive(:current?).and_return(false)
      allow(bar).to receive(:installed?).and_return(false)
      allow(bar).to receive(:to_s).and_return('bar')

      baz = double('baz')
      allow(baz).to receive(:current?).and_return(false)
      allow(baz).to receive(:installed?).and_return(true)
      allow(baz).to receive(:to_s).and_return('baz')

      [foo, bar, baz]
    end

    output = []
    allow(STDOUT).to receive(:puts) { |*args|
      output << args.first.to_s + "\n"
    }
    allow(STDOUT).to receive(:print) { |*args|
      output << args.first.to_s
    }

    Evm::Command::List.new()

    expect(output.join).to eq("bar\nbaz [I]\n* foo [I]\n")
  end
end
