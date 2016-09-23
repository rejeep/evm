recipe 'emacs-25-travis' do
  tar_gz 'https://github.com/rejeep/evm/releases/download/v0.9.0/emacs-25-travis.tar.gz'

  install do
    copy build_path, installations_path
  end
end
