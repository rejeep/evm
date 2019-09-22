recipe 'emacs-26.2-travis-linux-xenial' do
  tar_gz 'https://www.dropbox.com/s/vk3lhjy82462zlh/emacs-26.2-travis-linux-xenial.tar.gz?dl=1'

  install do
    copy build_path, installations_path
  end
end
