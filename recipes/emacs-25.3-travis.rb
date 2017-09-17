recipe 'emacs-25.3-travis' do
  tar_gz 'https://github.com/rejeep/evm/releases/download/v0.11.0/emacs-25.3-travis.tar.gz'

  install do
    copy build_path, installations_path
  end
end
