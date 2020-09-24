recipe 'emacs-27.1-travis-linux-xenial' do
  tar_gz 'https://www.dropbox.com/s/57k8ijryc3lw7vv/emacs-27.1-travis-linux-xenial.tar.gz?dl=1'

  install do
    copy build_path, installations_path
  end
end
