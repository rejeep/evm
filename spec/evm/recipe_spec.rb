require 'spec_helper'

describe Evm::Recipe do
  describe '#name' do
    it 'should return recipe name' do
      allow(File).to receive(:read).with('foo.rb').and_return('recipe "foo" do end')
      allow(File).to receive(:read).with('bar.rb').and_return('recipe "bar" do end')

      expect(Evm::Recipe.new('foo.rb').name).to eq('foo')
      expect(Evm::Recipe.new('bar.rb').name).to eq('bar')
    end
  end

  describe '#read' do
    it 'should read recipe file' do
      expect(File).to receive(:read).twice.with('foo.rb').and_return('recipe "foo" do end')

      expect(Evm::Recipe.new('foo.rb').read).to eq('recipe "foo" do end')
    end
  end

  describe '.find' do
    it 'should return recipe with same name' do
      foo = double('foo', :name => 'foo')
      bar = double('bar', :name => 'bar')

      allow(Evm::Recipe).to receive(:all).and_return([foo, bar])
      expect(Evm::Recipe.find('foo')).to eq(foo)
      expect(Evm::Recipe.find('bar')).to eq(bar)
    end

    it 'should return nil if no recipe with same name' do
      expect(Evm::Recipe.find('foo')).to be_nil
    end
  end

  describe '.all' do
    it 'should return an array of all recipes' do
      allow(File).to receive(:read).with('foo.rb').and_return('recipe "foo" do end')
      allow(File).to receive(:read).with('bar.rb').and_return('recipe "bar" do end')

      allow(Dir).to receive(:glob).and_return(['foo.rb', 'bar.rb'])

      expect(Evm::Recipe.all.size).to eq(2)
    end
  end
end
