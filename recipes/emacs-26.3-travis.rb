recipe 'emacs-26.3-travis' do
  tar_gz 'https://github.com/rejeep/evm/releases/download/v0.17.0/emacs-26.3-travis.tar.gz'

  install do
    copy build_path, installations_path
  end
end
