recipe 'emacs-23.4' do
  tar_gz 'http://ftpmirror.gnu.org/emacs/emacs-23.4.tar.gz'

  osx do
    option '--with-ns'
    option '--without-x'
    option '--without-dbus'
  end

  linux do
    crt_dir = File.dirname(`gcc -print-file-name=crt1.o`)

    option '--prefix', installation_path
    option "--with-crt-dir=#{crt_dir}"
    option '--without-gif'
  end

  install do
    configure
    make 'bootstrap'
    make 'install'

    osx do
      copy File.join(build_path, 'nextstep', 'Emacs.app'), installation_path
    end
  end
end
