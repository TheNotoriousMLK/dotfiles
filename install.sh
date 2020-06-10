#!/usr/bin/env bash

set -uo pipefail

DOTFILES_ROOT=$(pwd -P)
SHELL_DIR=$DOTFILES_ROOT/shell
PACKAGES_DIR=$DOTFILES_ROOT/packages
APT_DIR=$PACKAGES_DIR/apt
SNAP_DIR=$PACKAGES_DIR/snap
BREW_DIR=$PACKAGES_DIR/brew

BREW_INSTALLED=false

UPDATE_BREW=false
SKIP_BREW=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --update-brew)
      UPDATE_BREW=true
      ;;
    --skip-brew)
      SKIP_BREW=true
      ;;
  esac
  shift
done

source $SHELL_DIR/print.sh
source $SHELL_DIR/funcs.sh

remove_error_log

source $APT_DIR/apt_sources.sh
source $APT_DIR/apt_install.sh
source $SNAP_DIR/snap_install.sh
source $BREW_DIR/install_brew.sh
source $BREW_DIR/brew_sources.sh
source $BREW_DIR/brew_install.sh

install_packages() {
  xcode_install_packages
  apt_install_packages
  snap_install_packages
  brew_install_packages
  install_font_packages
  install_git_keyring
  if [ $BREW_INSTALLED == "true" ]; then
    echo "Brew has been installed and you will need to reboot."
    do_reboot
  fi
}

xcode_install_packages() {
  if is_mac; then
    source $PACKAGES_DIR/xcode.sh
    install_xcode_tools
  fi
}

apt_install_packages() {
  if is_debian; then
    apt_add_sources
    apt_install
  fi
}

snap_install_packages() {
  if is_linux && !(is_wsl); then
    snap_install
  fi
}

brew_install_packages() {
  if [ $SKIP_BREW == "false" ]; then
    install_brew
    brew_add_sources
    brew_update
    brew_install
    cask_install
    brew cleanup > /dev/null 2>&1
  fi
}

install_font_packages() {
  if is_linux && !(is_wsl); then
    source $PACKAGES_DIR/fonts.sh
    install_fonts
  fi
}

install_git_keyring() {
  if !(is_mac) && !(is_wsl); then
    if [ ! -x '/usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret' ]; then
      sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret \
        > /dev/null 2> error.log
      is_success "Keyring for git setup" "Keyring for git failed to be set up"
    fi
  fi
}

install_packages
