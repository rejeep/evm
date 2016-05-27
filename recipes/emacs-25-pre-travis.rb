recipe 'emacs-25-pre-travis' do
  tar_gz 'https://github.com/rejeep/evm/releases/download/v0.8.0/emacs-25-pre-travis.tar.gz'

  install do
    copy build_path, installations_path
  end
end
