recipe 'emacs-25.1' do
  tar_xz 'http://ftpmirror.gnu.org/emacs/emacs-25.1.tar.gz'

  osx do
    option '--with-modules'
    option '--with-ns'
    option '--without-x'
    option '--without-dbus'
  end

  linux do
    option '--with-modules'
    option '--prefix', installation_path
    option '--without-gif'
  end

  install do
    configure
    make 'install'

    osx do
      copy File.join(build_path, 'nextstep', 'Emacs.app'), installation_path
    end
  end
end
