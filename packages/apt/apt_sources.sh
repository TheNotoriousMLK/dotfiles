apt_add_sources() {
  apt_add_ppas

  if ! is_wsl; then
    apt_add_vivaldi
  fi
}

apt_add_ppas() {
  local repos=(`cat $APT_DIR/repos.txt`)
  local repos_not_wsl=(`cat $APT_DIR/repos_not_wsl.txt`)

  if ! is_wsl; then
    repos=("${repos[@]}" "${repos_not_wsl[@]}")
  fi

  apt_add_repos "${repos[@]}"
}

apt_add_vivaldi() {
  if ! apt_is_repo_added vivaldi; then
    info "Adding Vivaldi GPG key"
    wget -qO- http://repo.vivaldi.com/stable/linux_signing_key.pub \
      | sudo apt-key add - > /dev/null 2> error.log
    is_success "Vivaldi GPG key added" "Vivaldi GPG key could not be added"

    info "Adding Vivaldi repo"
    sudo add-apt-repository \
      "deb [arch=i386,amd64] http://repo.vivaldi.com/stable/deb/ stable main" \
      > /dev/null 2> error.log
    is_success "Vivaldi repo added" "Vivaldi repo could not be added"
  fi
}
