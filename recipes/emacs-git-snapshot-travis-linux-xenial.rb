recipe 'emacs-git-snapshot-travis-linux-xenial' do
  tar_gz 'https://www.dropbox.com/s/j4t3tp1uxz0rjc9/emacs-git-snapshot-travis-linux-xenial.tar.gz?dl=1'

  install do
    copy build_path, installations_path
  end
end
