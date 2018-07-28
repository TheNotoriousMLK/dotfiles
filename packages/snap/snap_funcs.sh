snap_add_pkgs() {
  local pkgs=("$@")

  for pkg in "${pkgs[@]}"
  do
    if command_exists snap; then
      snap_add_pkg $pkg
    fi
  done
}

snap_add_pkg() {
  local pkg=$(echo $1 | cut -d ":" -f 1)
  local opts=$(echo $1 | cut -d ":" -f 2)

  if ! snap_is_installed $pkg; then
    info "$pkg is installing"
    if [ -z $opts ]; then
      sudo snap install $pkg > /dev/null 2> error.log
      is_success "$pkg is installed" "$pkg failed to install (snap)"
    else
      eval "sudo snap install $opts $pkg" > /dev/null 2> error.log
      is_success "$pkg is installed" "$pkg failed to install (snap)"
    fi
  fi
}

snap_is_installed() {
  local pkg=$1
  snap list | cut -d " " -f 1 | grep -q "^$pkg\$" > /dev/null 2>&1
}
