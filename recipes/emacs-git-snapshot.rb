recipe 'emacs-git-snapshot' do
  git 'http://git.savannah.gnu.org/r/emacs.git'

  osx do
    option '--with-ns'
    option '--without-x'
    option '--without-dbus'
  end

  linux do
    option '--prefix', installation_path
  end

  install do
    autogen
    configure
    make 'bootstrap'
    make 'install'

    osx do
      copy build_path.join('nextstep', 'Emacs.app'), installation_path
    end
  end
end
