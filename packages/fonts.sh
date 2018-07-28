install_fonts() {
  if ! is_debian; then
    info "Installing Powerline fonts"
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd $DOTFILES_ROOT
    rm -rf fonts
    success "Powerline fonts installed"
  fi

  install_jetbrains_mono
  install_cascadia_code
}

install_jetbrains_mono() {
  local ver="1.0.6"
  local file="$FONTS_DIR/fonts.zip"
  local out="$HOME/.local/share/fonts"
  local any_out="$out/JetBrainsMono-*"
  local out_dir="$out/JetBrainsMono-$ver"

  if [ ! -d $out_dir ]; then
    if ls $any_out > /dev/null 2>&1; then
      info "Removing old JetBrains Mone"
      rm -rf $any_out
      success "Old JetBrains Mono removed"
    fi

    curl -Lo $file \
      "https://github.com/JetBrains/JetBrainsMono/releases/download/v$ver/JetBrainsMono-$ver.zip"
    if [ ! -d "$out" ]; then
      mkdir -p $out
    fi
    info "Installing JetBrains Mono"
    unzip -qq $file -d $out > /dev/null && fc-cache -f > /dev/null 2>&1
    rm $file
    success "JetBrains Mono has been installed"
  fi
}

install_cascadia_code() {
  local ver="2005.15"
  local file="$FONTS_DIR/fonts.zip"
  local out="$HOME/.local/share/fonts/CascadiaCode_"
  local any_out="$out*"
  local out_dir="$out$ver"

  if [ ! -d $out_dir ]; then
    if ls $any_out > /dev/null 2>&1; then
      info "Removing old Cascadia Code"
      rm -rf $any_out
      success "Old Cascadia Code removed"
    fi

    curl -Lo $file \
      "https://github.com/microsoft/cascadia-code/releases/download/v$ver/CascadiaCode_$ver.zip"
    if [ ! -d "$out_dir" ]; then
      mkdir -p $out_dir
    fi
    info "Installing Cascadia Code"
    unzip -qq $file -d $out_dir > /dev/null && fc-cache -f > /dev/null 2>&1
    rm $file
    success "Cascadia Code has been installed"
  fi
}
