source $BREW_DIR/brew_funcs.sh

brew_install() {
  local pkgs=(`cat $BREW_DIR/packages.txt`)
  local pkgs_not_wsl=(`cat $BREW_DIR/packages_not_wsl.txt`)

  if ! is_wsl; then
    pkgs=("${pkgs[@]}" "${pkgs_not_wsl[@]}")

    if is_linux; then
      pkgs_linux=(`cat $BREW_DIR/packages_linux.txt`)
      pkgs=("${pkgs[@]}" "${pkgs_linux[@]}")
    fi
  fi

  brew_add_pkgs "${pkgs[@]}"
}

cask_install() {
  if is_mac; then
    local pkgs_cask=(`cat $BREW_DIR/packages_cask.txt`)
    cask_add_pkgs "${pkgs_cask[@]}"
  fi
}

brew_update() {
  if [ $UPDATE_BREW == "true" ]; then
    brew update > /dev/null 2>&1
    brew upgrade > /dev/null 2>&1
    success "Brew updated"
  fi
}
