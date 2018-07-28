brew_add_sources() {
  if is_mac; then
    declare -a taps=(
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
    )

    for tap in "${taps[@]}"
    do
      add_tap $tap
    done
  fi
}

add_tap() {
  local tap=$1
  if ! tap_is_installed $tap; then
    info "Adding $tap to brew"
    brew tap $tap > /dev/null 2> error.log
    is_success "$tap added to brew" "$tap could not be added to brew"
  fi
}

tap_is_installed() {
  local tap=$1
  brew tap | grep -q "^$tap\$" > /dev/null 2>&1
}
