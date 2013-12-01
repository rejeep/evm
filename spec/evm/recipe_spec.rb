require 'spec_helper'

describe Evm::Recipe do
  describe '#name' do
    it 'should return recipe name' do
      File.stub(:read).with('foo.rb').and_return('recipe "foo" do end')
      File.stub(:read).with('bar.rb').and_return('recipe "bar" do end')

      Evm::Recipe.new('foo.rb').name.should == 'foo'
      Evm::Recipe.new('bar.rb').name.should == 'bar'
    end
  end

  describe '#read' do
    it 'should read recipe file' do
      File.should_receive(:read).twice.with('foo.rb').and_return('recipe "foo" do end')

      Evm::Recipe.new('foo.rb').read.should == 'recipe "foo" do end'
    end
  end

  describe '.find' do
    it 'should return recipe with same name' do
      foo = double('foo', :name => 'foo')
      bar = double('bar', :name => 'bar')

      Evm::Recipe.stub(:all).and_return([foo, bar])
      Evm::Recipe.find('foo').should == foo
      Evm::Recipe.find('bar').should == bar
    end

    it 'should return nil if no recipe with same name' do
      Evm::Recipe.find('foo').should be_nil
    end
  end

  describe '.all' do
    it 'should return an array of all recipes' do
      File.stub(:read).with('foo.rb').and_return('recipe "foo" do end')
      File.stub(:read).with('bar.rb').and_return('recipe "bar" do end')

      Dir.stub(:glob).and_return(['foo.rb', 'bar.rb'])

      Evm::Recipe.all.size.should == 2
    end
  end
end
