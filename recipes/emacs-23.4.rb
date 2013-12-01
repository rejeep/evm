recipe 'emacs-24.3' do
  tar_gz 'emacs-24.3.tar.gz'

  osx do
    option '--with-ns'
    option '--without-x'
    option '--without-dbus'
  end

  linux do
    crt_dir = File.dirname(`gcc -print-file-name=crt1.o`)

    option '--prefix', installation_path
    option "--with-crt-dir=#{crt_dir}"
  end

  install do
    configure
    make 'bootstrap'
    make 'install'

    osx do
      copy build_path.join('nextstep', 'Emacs.app'), installation_path
    end
  end
end
