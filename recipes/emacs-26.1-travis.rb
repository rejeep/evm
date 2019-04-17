recipe 'emacs-26.1-travis' do
  tar_gz 'https://github.com/rejeep/evm/releases/download/v0.15.0/emacs-26.1-travis.tar.gz'

  install do
    copy build_path, installations_path
  end
end
