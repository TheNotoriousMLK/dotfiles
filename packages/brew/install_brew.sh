install_brew() {
  if ! command_exists brew; then
    info "Installing Brew"
    /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" \
      > /dev/null 2> error.log
    is_success "Brew installed" "Brew could not be installed"

    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew \
      && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile \
      && echo "$($(brew --prefix)/bin/brew shellenv)" >> ~/.bash_profile
    echo "$($(brew --prefix)/bin/brew shellenv)" >> ~/.profile
  fi
}
