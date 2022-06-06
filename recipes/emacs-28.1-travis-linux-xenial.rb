recipe 'emacs-28.1-travis-linux-xenial' do
  tar_gz 'https://www.dropbox.com/s/b055iaypjy2d4ul/emacs-28.1-travis-linux-xenial.tar.gz?dl=1'

  install do
    copy build_path, installations_path
  end
end
