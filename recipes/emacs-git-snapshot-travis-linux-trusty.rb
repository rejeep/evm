recipe 'emacs-git-snapshot-travis-linux-trusty' do
  tar_gz 'https://www.dropbox.com/s/b1jmlm8d8ubxi52/emacs-git-snapshot-travis-linux-trusty.tar.gz?dl=1'

  install do
    copy build_path, installations_path
  end
end
