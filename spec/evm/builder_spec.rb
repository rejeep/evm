require 'spec_helper'

describe Evm::Builder do
  describe Evm::Builder::Dsl do
    before do
      @tar_gz_url = 'http://domain.com/foo.tar.gz'
      @git_url = 'git://domain.com/emacs.git'

      @dsl = Evm::Builder::Dsl.new
      @dsl.stub(:path).and_return('/path/to')
    end

    describe '#tar_gz' do
      it 'should download and extract tar' do
        tar_file_path = '/tmp/evm/tmp/name.tar.gz'

        remote_file = double('remote_file')
        remote_file.should_receive(:download).with(tar_file_path)

        Evm::RemoteFile.should_receive(:new).with(@tar_gz_url).and_return(remote_file)

        tar_file = double('tar_file')
        tar_file.should_receive(:extract).with('/tmp/evm/tmp', 'name')

        Evm::TarFile.should_receive(:new).with(tar_file_path).and_return(tar_file)

        FileUtils.should_receive(:mkdir).with('/tmp/evm/tmp/name')

        @dsl.recipe 'name' do
          @dsl.tar_gz(@tar_gz_url)
        end
      end
    end

    describe '#git' do
      before do
        @git_repo = double('git_repo')
        @git_repo.stub(:exist?).and_return(true)
        @git_repo.stub(:clone)
        @git_repo.stub(:pull)

        Evm::Git.stub(:new).and_return(@git_repo)
      end

      it 'should pull if exist' do
        @git_repo.stub(:exist?).and_return(true)
        @git_repo.should_receive(:pull)

        @dsl.recipe 'name' do
          @dsl.git(@git_url)
        end
      end

      it 'should clone if not exist' do
        @git_repo.stub(:exist?).and_return(false)
        @git_repo.should_receive(:clone).with(@git_url)

        @dsl.recipe 'name' do
          @dsl.git(@git_url)
        end
      end
    end

    describe '#osx' do
      it 'should yield if osx' do
        Evm::Os.stub(:osx?).and_return(true)

        expect { |block|
          @dsl.osx(&block)
        }.to yield_control
      end

      it 'should not yield if not osx' do
        Evm::Os.stub(:osx?).and_return(false)

        expect { |block|
          @dsl.osx(&block)
        }.not_to yield_control
      end
    end

    describe '#linux' do
      it 'should yield if linux' do
        Evm::Os.stub(:linux?).and_return(true)

        expect { |block|
          @dsl.linux(&block)
        }.to yield_control
      end

      it 'should not yield if not linux' do
        Evm::Os.stub(:linux?).and_return(false)

        expect { |block|
          @dsl.linux(&block)
        }.not_to yield_control
      end
    end

    describe '#option' do
      it 'should add option without value' do
        @dsl.option '--foo'
        @dsl.instance_variable_get('@options').should =~ ['--foo']
      end

      it 'should add option with value' do
        @dsl.option '--foo', 'bar'
        @dsl.instance_variable_get('@options').should =~ ['--foo', 'bar']
      end

      it 'should add multiple options' do
        @dsl.option '--foo'
        @dsl.option '--foo', 'bar'
        @dsl.option '--bar', 'baz'
        @dsl.option '--qux'
        @dsl.instance_variable_get('@options').should =~
          ['--foo', '--foo', 'bar', '--bar', 'baz', '--qux']
      end
    end

    describe '#install' do
      it 'should yield' do
        expect { |block|
          @dsl.install(&block)
        }.to yield_control
      end
    end

    describe '#autogen' do
      it 'should run make command with target' do
        @dsl.should_receive(:run_command).with('./autogen.sh')
        @dsl.autogen
      end
    end

    describe '#configure' do
      it 'should configure when no options' do
        @dsl.should_receive(:run_command).with('./configure')
        @dsl.configure
      end

      it 'should configure when single option' do
        @dsl.should_receive(:run_command).with('./configure', '--foo', 'bar')
        @dsl.option '--foo', 'bar'
        @dsl.configure
      end

      it 'should configure when multiple options' do
        @dsl.should_receive(:run_command).with('./configure', '--foo', 'bar', '--baz')
        @dsl.option '--foo', 'bar'
        @dsl.option '--baz'
        @dsl.configure
      end
    end

    describe '#make' do
      it 'should run make command with target' do
        @dsl.should_receive(:run_command).with('make', 'foo')
        @dsl.make('foo')
      end
    end

    describe '#build_path' do
      it 'should return package build path' do
        @dsl.recipe 'name' do
          @dsl.build_path.should == '/tmp/evm/tmp/name'
        end
      end
    end

    describe '#builds_path' do
      it 'should return package builds path' do
        @dsl.recipe 'name' do
          @dsl.builds_path.should == '/tmp/evm/tmp'
        end
      end
    end

    describe '#installation_path' do
      it 'should return package installation path' do
        @dsl.recipe 'name' do
          @dsl.installation_path.should == '/tmp/evm/name'
        end
      end
    end

    describe '#installations_path' do
      it 'should return package installations path' do
        @dsl.recipe 'name' do
          @dsl.installations_path.should == '/tmp/evm'
        end
      end
    end

    describe '#platform_name' do
      it 'should platform name' do
        Evm::Os.stub(:platform_name).and_return(:foo)

        @dsl.platform_name.should == :foo
      end
    end

    describe '#copy' do
      it 'should copy recursively' do
        FileUtils.should_receive(:cp_r).with('from', 'to', preserve: true)

        @dsl.copy 'from', 'to'
      end
    end
  end
end
