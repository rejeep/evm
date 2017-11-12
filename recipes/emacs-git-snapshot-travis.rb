recipe 'emacs-git-snapshot-travis' do
  tar_gz 'https://github.com/rejeep/evm/releases/download/v0.12.0/emacs-git-snapshot-travis.tar.gz'

  install do
    copy build_path, installations_path
  end
end
