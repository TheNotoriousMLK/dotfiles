is_mac() {
  [ $(uname -s) = "Darwin" ]
}

is_linux() {
  [ $(uname -s) = "Linux" ]
}

is_wsl() {
  grep -iq microsoft /proc/version
}

is_debian() {
  [ -f "/etc/debian_version" ]
}

is_vbox() {
  lspci | grep -q "VirtualBox"
}

command_exists() {
  type $1 > /dev/null 2>&1
}

remove_error_log() {
  if [ -f $DOTFILES_ROOT/error.log ]; then
    rm $DOTFILES_ROOT/error.log
  fi
}

is_success() {
  local status=$?
  local yes=$1
  local no=$2

  if [ $status == 0 ]; then
    success "$yes"
    # needed becasue brew install writes to stderr for some unknown reason
    remove_error_log
  else
    fail "$no"
  fi
}
