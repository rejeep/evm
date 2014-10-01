recipe 'emacs-24.1-bin' do
  tar_gz 'https://github.com/rejeep/evm-bin/raw/master/emacs-24.1-%s.tar.gz' % platform_name

  install do
    copy build_path, installations_path
  end
end
