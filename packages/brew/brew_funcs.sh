brew_add_pkgs() {
  local pkgs=("$@")

  for pkg in "${pkgs[@]}"
  do
    if command_exists brew; then
      brew_add_pkg $pkg
    fi
  done
}

brew_add_pkg() {
  local pkg=$(echo $1 | cut -d ":" -f 1)
  local opts=$(echo $1 | cut -d ":" -f 2)

  if ! brew_is_installed $pkg; then
    if [ -z $opts ]; then
      brew install $pkg > /dev/null 2> error.log
      is_success "$pkg is installed" "$pkg failed to install (brew)"
    else
      eval "brew install $pkg $opts" > /dev/null 2> error.log
      is_success "$pkg is installed" "$pkg failed to install (brew)"
    fi
  fi
}

brew_is_installed() {
  local pkg=$1
  brew ls --versions | cut -d " " -f 1 | grep -q "^$pkg\$" > /dev/null 2>&1
}

cask_add_pkgs() {
  local pkgs=("$@")

  for pkg in "${pkgs[@]}"
  do
    if command_exists brew; then
      cask_add_pkg $pkg
    fi
  done
}

cask_add_pkg() {
  local pkg=$(echo $1 | cut -d ":" -f 1)
  local opts=$(echo $1 | cut -d ":" -f 2)

  if ! cask_is_installed $pkg; then
    if [ -z $opts ]; then
      brew cask install $pkg > /dev/null 2> error.log
      is_success "$pkg is installed" "$pkg failed to install (cask)"
    else
      eval "brew cask install $pkg $opts" > /dev/null 2> error.log
      is_success "$pkg is installed" "$pkg failed to install (cask)"
    fi
  fi
}

cask_is_installed() {
  local pkg=$1
  brew cask ls --versions | cut -d " " -f 1 | grep -q "^$pkg\$" \
    > /dev/null 2>&1
}
