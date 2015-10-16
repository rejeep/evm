recipe 'emacs-24.1-travis' do
  tar_gz 'https://github.com/rejeep/evm/releases/download/v0.6.1/emacs-24.1-travis.tar.gz'

  install do
    copy build_path, installations_path
  end
end
