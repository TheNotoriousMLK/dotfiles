count=0

apt_add_pkgs() {
  count=0
  local pkgs=("$@")

  for pkg in "${pkgs[@]}"
  do
    apt_add_pkg $pkg
  done

  if ((count > 0)); then
    sudo apt autoremove -y > /dev/null 2> error.log
    is_success "Packages cleaned up" "Packages could not be cleaned up (apt)"
  fi
}

apt_add_pkg() {
  local pkg=$1

  if ! apt_is_installed $pkg; then
    info "$pkg is installing"
    sudo apt-get install -y "$pkg" > /dev/null 2> error.log
    is_success "$pkg installed" "$pkg failed to install (apt)"
    count=$((count + 1))
  fi
}

apt_is_installed() {
  dpkg -s $1 > /dev/null 2>&1
}

apt_add_repos() {
  count=0
  local ppas=("$@")

  for ppa in "${ppas[@]}"
  do
    apt_add_repo $ppa
  done

  if ((count > 0)); then
    sudo apt update > /dev/null 2> error.log
    sudo apt upgrade -y > /dev/null 2> error.log
    is_success "Package sources updated" "Package sources failed to update (apt)"
  fi
}

apt_add_repo() {
  local ppa=$1
  if ! apt_is_repo_added $ppa; then
    info "Adding repo $ppa"
    sudo add-apt-repository -y "ppa:$ppa" > /dev/null 2> error.log
    is_success "Repo $ppa added" "Repo $ppa addition failed"
    count=$((count + 1))
  fi
}

apt_is_repo_added() {
  local source1=/etc/apt/sources.list
  local source2=/etc/apt/sources.list.d/*
  local repo=$1
  grep -q "^deb .*$repo" $source1 $source2 > /dev/null 2>&1
}
