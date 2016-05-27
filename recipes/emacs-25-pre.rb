recipe 'emacs-25-pre' do
  tar_xz 'http://alpha.gnu.org/gnu/emacs/pretest/emacs-25.0.94.tar.xz'

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
    configure
    make 'install'

    osx do
      copy File.join(build_path, 'nextstep', 'Emacs.app'), installation_path
    end
  end
end
