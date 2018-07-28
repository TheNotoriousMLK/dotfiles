install_xcode_tools() {
  if [ -z $(xcode-select -p) ]; then
    info "Installing XCode tools"
    xcode-select --install > /dev/null 2>&1
    is_success "XCode tools installed" "XCode tools install failed"
  fi
}
