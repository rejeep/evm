recipe 'emacs-26.3-travis' do
  tar_gz 'https://www.dropbox.com/s/q2rptzjhl3dkx5w/emacs-26.3-travis.tar.gz?dl=1'

  install do
    copy build_path, installations_path
  end
end
