require 'spec_helper'

describe Evm::Builder do
  describe Evm::Builder::Dsl do
    before do
      @tar_gz_url = 'http://domain.com/foo.tar.gz'
      @git_url = 'git://domain.com/emacs.git'

      @dsl = Evm::Builder::Dsl.new
      allow(@dsl).to receive(:path).and_return('/path/to')
    end

    describe '#tar_gz' do
      it 'should download and extract tar' do
        tar_file_path = '/tmp/evm/tmp/name.tar.gz'

        remote_file = double('remote_file')
        expect(remote_file).to receive(:download).with(tar_file_path)

        expect(Evm::RemoteFile).to receive(:new).with(@tar_gz_url).and_return(remote_file)

        tar_file = double('tar_file')
        expect(tar_file).to receive(:extract).with('/tmp/evm/tmp', 'name')

        expect(Evm::TarFile).to receive(:new).with(tar_file_path).and_return(tar_file)

        expect(FileUtils).to receive(:mkdir_p).with('/tmp/evm/tmp/name')

        @dsl.recipe 'name' do
          @dsl.tar_gz(@tar_gz_url)
        end
      end
    end

    describe '#git' do
      before do
        @git_repo = double('git_repo')
        allow(@git_repo).to receive(:exist?).and_return(true)
        allow(@git_repo).to receive(:clone)
        allow(@git_repo).to receive(:pull)

        allow(Evm::Git).to receive(:new).and_return(@git_repo)
      end

      it 'should pull if exist' do
        allow(@git_repo).to receive(:exist?).and_return(true)
        expect(@git_repo).to receive(:pull)

        @dsl.recipe 'name' do
          @dsl.git(@git_url)
        end
      end

      it 'should clone if not exist' do
        allow(@git_repo).to receive(:exist?).and_return(false)
        expect(@git_repo).to receive(:clone).with(@git_url, nil)

        @dsl.recipe 'name' do
          @dsl.git(@git_url)
        end
      end

      it 'should clone a branch' do
        allow(@git_repo).to receive(:exist?).and_return(false)
        expect(@git_repo).to receive(:clone).with(@git_url, 'branch')

        @dsl.recipe 'name' do
          @dsl.git(@git_url, 'branch')
        end
      end
    end

    describe '#osx' do
      it 'should yield if osx' do
        allow(Evm::Os).to receive(:osx?).and_return(true)

        expect { |block|
          @dsl.osx(&block)
        }.to yield_control
      end

      it 'should not yield if not osx' do
        allow(Evm::Os).to receive(:osx?).and_return(false)

        expect { |block|
          @dsl.osx(&block)
        }.not_to yield_control
      end
    end

    describe '#linux' do
      it 'should yield if linux' do
        allow(Evm::Os).to receive(:linux?).and_return(true)

        expect { |block|
          @dsl.linux(&block)
        }.to yield_control
      end

      it 'should not yield if not linux' do
        allow(Evm::Os).to receive(:linux?).and_return(false)

        expect { |block|
          @dsl.linux(&block)
        }.not_to yield_control
      end
    end

    describe '#option' do
      it 'should add option without value' do
        @dsl.option '--foo'
        expect(@dsl.instance_variable_get('@options')).to eq(['--foo'])
      end

      it 'should add option with value' do
        @dsl.option '--foo', 'bar'
        expect(@dsl.instance_variable_get('@options')).to eq(['--foo', 'bar'])
      end

      it 'should add multiple options' do
        @dsl.option '--foo'
        @dsl.option '--foo', 'bar'
        @dsl.option '--bar', 'baz'
        @dsl.option '--qux'
        expect(@dsl.instance_variable_get('@options')).to eq(['--foo', '--foo', 'bar', '--bar', 'baz', '--qux'])
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
        expect(@dsl).to receive(:run_command).with('./autogen.sh')
        @dsl.autogen
      end
    end

    describe '#configure' do
      it 'should configure when no options' do
        expect(@dsl).to receive(:run_command).with('./configure')
        @dsl.configure
      end

      it 'should configure when single option' do
        expect(@dsl).to receive(:run_command).with('./configure', '--foo', 'bar')
        @dsl.option '--foo', 'bar'
        @dsl.configure
      end

      it 'should configure when multiple options' do
        expect(@dsl).to receive(:run_command).with('./configure', '--foo', 'bar', '--baz')
        @dsl.option '--foo', 'bar'
        @dsl.option '--baz'
        @dsl.configure
      end
    end

    describe '#make' do
      it 'should run make command with target' do
        expect(@dsl).to receive(:run_command).with('make', 'foo')
        @dsl.make('foo')
      end
    end

    describe '#build_path' do
      it 'should return package build path' do
        @dsl.recipe 'name' do
          expect(@dsl.build_path).to eq('/tmp/evm/tmp/name')
        end
      end
    end

    describe '#builds_path' do
      it 'should return package builds path' do
        @dsl.recipe 'name' do
          expect(@dsl.builds_path).to eq('/tmp/evm/tmp')
        end
      end
    end

    describe '#installation_path' do
      it 'should return package installation path' do
        @dsl.recipe 'name' do
          expect(@dsl.installation_path).to eq('/tmp/evm/name')
        end
      end
    end

    describe '#installations_path' do
      it 'should return package installations path' do
        @dsl.recipe 'name' do
          expect(@dsl.installations_path).to eq('/tmp/evm')
        end
      end
    end

    describe '#platform_name' do
      it 'should platform name' do
        allow(Evm::Os).to receive(:platform_name).and_return(:foo)

        expect(@dsl.platform_name).to eq(:foo)
      end
    end

    describe '#copy' do
      it 'copies all files recursively and preserves file attributes' do
        expect(@dsl).to receive(:run_command).with('cp -a from to')
        @dsl.copy 'from', 'to'
      end
    end
  end
end
