recipe 'emacs-26.1' do
  tar_gz 'http://ftpmirror.gnu.org/emacs/emacs-26.1.tar.gz'

  osx do
    option '--with-ns'
    option '--without-x'
    option '--without-dbus'
  end

  linux do
    option '--prefix', installation_path
    option '--without-gif'
  end

  install do
    autogen
    configure
    make 'bootstrap'
    make 'install'

    osx do
      copy File.join(build_path, 'nextstep', 'Emacs.app'), installation_path
    end
  end
end
