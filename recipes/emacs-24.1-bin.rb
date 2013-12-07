recipe 'emacs-24.1-bin' do
  # tar_gz 'http://s3.amazonaws.com/emacs-evm/emacs-24.1-%s.tar.gz' % platform_name
  tar_gz 'http://localhost:8000/emacs-24.1-osx.tar.gz'

  install do
    copy build_path, installations_path
  end
end
