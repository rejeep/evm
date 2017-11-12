recipe 'emacs-26-pretest-travis' do
  tar_gz 'https://github.com/rejeep/evm/releases/download/v0.12.0/emacs-26-pretest-travis.tar.gz'

  install do
    copy build_path, installations_path
  end
end
