recipe 'remacs-git-snapshot-travis' do
  tar_gz 'https://github.com/rejeep/evm/releases/download/v0.9.1/remacs-git-snapshot-travis.tar.gz'

  install do
    copy build_path, installations_path
  end
end
