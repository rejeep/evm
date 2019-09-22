recipe 'emacs-26.3-travis-linux-xenial' do
  tar_gz 'https://www.dropbox.com/s/xd28wgjtlfvgrlj/emacs-26.3-travis-linux-xenial.tar.gz?dl=1'

  install do
    copy build_path, installations_path
  end
end
