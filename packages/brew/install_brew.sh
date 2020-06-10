install_brew() {
  if ! command_exists brew; then
    info "Installing Brew"
    /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    success "Brew installed"

    BREW_INSTALLED=true
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew \
      && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile \
      && echo "$($(brew --prefix)/bin/brew shellenv)" >> ~/.bash_profile
    test -r ~/.bashrc \
      && echo "$($(brew --prefix)/bin/brew shellenv)" >> ~/.bashrc
    echo "$($(brew --prefix)/bin/brew shellenv)" >> ~/.profile
  fi
}
