recipe 'emacs-23.4-bin' do
  tar_gz 'emacs-23.4-%s.tar.gz' % platform_name

  install do
    copy build_path, installation_path
  end
end
