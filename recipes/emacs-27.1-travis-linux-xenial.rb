recipe 'emacs-27.1-travis-linux-xenial' do
  tar_gz 'https://github.com/rejeep/evm/releases/download/v0.21.0/emacs-27.1-travis-linux-xenial.tar.gz'

  install do
    copy build_path, installations_path
  end
end
