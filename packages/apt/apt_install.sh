source $APT_DIR/apt_funcs.sh

apt_install() {
  local pkgs=(`cat $APT_DIR/packages.txt`)
  local pkgs_not_wsl=(`cat $APT_DIR/packages_not_wsl.txt`)
  local pkgs_vbox=(`cat $APT_DIR/packages_vbox.txt`)

  if ! is_wsl; then
    pkgs=("${pkgs[@]}" "${pkgs_not_wsl[@]}")
  fi

  if is_vbox; then
    pkgs=("${pkgs[@]}" "${pkgs_vbox[@]}")
  fi

  apt_add_pkgs "${pkgs[@]}"
}
