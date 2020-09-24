recipe 'emacs-27.1-travis-linux-trusty' do
  tar_gz 'https://www.dropbox.com/s/0g9bwt0vywrvl18/emacs-27.1-travis-linux-trusty.tar.gz?dl=1'

  install do
    copy build_path, installations_path
  end
end
