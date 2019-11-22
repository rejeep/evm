recipe 'emacs-git-snapshot-travis-linux-xenial' do
  tar_gz 'https://github.com/rejeep/evm/releases/download/v0.20.0/emacs-git-snapshot-travis-linux-xenial.tar.gz'

  install do
    copy build_path, installations_path
  end
end
