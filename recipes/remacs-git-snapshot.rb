recipe 'remacs-git-snapshot' do
  git 'https://github.com/Wilfred/remacs.git'

  osx do
    option '--with-ns'
    option '--with-modules'
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
