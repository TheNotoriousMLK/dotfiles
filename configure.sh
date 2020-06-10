#!/usr/bin/env bash

set -uo pipefail

DOTFILES_ROOT=$(pwd -P)
SHELL_DIR=$DOTFILES_ROOT/shell
SUDO_DIR=$DOTFILES_ROOT/sudo
VBOX_DIR=$DOTFILES_ROOT/vbox
GIT_DIR=$DOTFILES_ROOT/git
VIM_DIR=$DOTFILES_ROOT/vim
THEMES_DIR=$DOTFILES_ROOT/themes
FISH_DIR=$DOTFILES_ROOT/fish
GNOME_DIR=$DOTFILES_ROOT/gnome

overwrite_all=false
backup_all=false
skip_all=false

SKIP_SUDOERS=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --skip-sudoers)
      SKIP_SUDOERS=true
      ;;
  esac
  shift
done

source $SHELL_DIR/print.sh
source $SHELL_DIR/funcs.sh
source $SUDO_DIR/sudoers.sh
source $VBOX_DIR/vbox.sh

remove_error_log

configure() {
  if [ $SKIP_SUDOERS == "false" ]; then
    set_sudoers
  fi
  add_to_vbox_group
  configure_git
  configure_vim
  configure_themes
  configure_gnome
  link_dotfiles
  configure_fish
}

configure_git() {
  setup_gitconfig
  link_dir_files $GIT_DIR
}

setup_gitconfig() {
  if [ ! -f "$GIT_DIR/gitconfig.local" ]; then
    info "Setting up gitconfig"

    local git_credential="/usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret"

    if is_mac; then
      git_credential=osxkeychain
    elif is_wsl; then
      git_credential="/mnt/c/Program\\\\\\\\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe"
    fi

    user " - What's your name?"
    read author_name
    user " - What's your email address?"
    read author_email

    sed -e "s/AUTHORNAME/$author_name/g" -e "s/AUTHOREMAIL/$author_email/g" \
      -e "s@GIT_CREDENTIAL_HELPER@$git_credential@g" \
      $GIT_DIR/gitconfig.local.example > $GIT_DIR/gitconfig.local

    success "Created gitconfig.local"
  fi
}

configure_vim() {
  link_dir_files $VIM_DIR
  setup_vundle
}

setup_vundle() {
  if [ ! -f $DOTFILES_ROOT/.vimplugins ]; then
    vim +PluginInstall +qall
    echo "Delete this file to install Vundle plugins for vim." > .vimplugins
  fi
}

configure_themes() {
  if is_linux && !(is_wsl); then
    link_dir_files $THEMES_DIR
  fi
}

configure_fish() {
  if command_exists fish; then
    local src=$FISH_DIR/omf
    local dst="$HOME/.config/omf"
    mkdir -p $HOME/.config
    link_file "$src" "$dst"
    set_shell_fish
  fi
}

set_shell_fish() {
  if [ "$(echo $SHELL)" != "/usr/local/bin/fish" ]; then
    info "The machine will need to be rebooted once the default shell is set."
    if [ ! -e '/usr/local/bin/fish' ]; then
      sudo ln -s "$(which fish)" /usr/local/bin/fish
      sh -c "$FISH_DIR/install_omf.fish"
    fi
    if ! (cat /etc/shells | grep -q fish); then
      sudo sh -c 'echo "/usr/local/bin/fish" >> /etc/shells'
      if (cat /etc/shells | grep -q fish); then
        success 'Fish added to /etc/shells'
      fi
    fi
    info "Setting Fish as default shell"
    chsh -s "/usr/local/bin/fish"
    is_success "Default shell changed to fish" \
      "Default shell could not be changed to fish"
    do_reboot
  fi
}

configure_gnome() {
  if is_linux && !(is_wsl); then
    while IFS= read -r setting
    do
      local ploc=$(echo $setting | cut -d "|" -f 1)
      local pname=$(echo $setting | cut -d "|" -f 2)
      local pval=$(echo $setting | cut -d "|" -f 3)
      gsettings set $ploc $pname $pval > /dev/null
    done < $GNOME_DIR/settings.txt
  fi
}

link_dir_files() {
  local dir=$1

  dir_files=$(find -H $dir -mindepth 1 -maxdepth 1 -type f \
    -not -path "*.example" -or -type d)
  for src in $dir_files
  do
    local dst="$HOME/.$(basename $src)"
    link_file "$src" "$dst"
  done
}

link_dotfiles() {
  for src in $(find -H $DOTFILES_ROOT -maxdepth 1 -name ".*" -type f \
    -not -path "*.gitignore" -not -path "*.vimplugins")
  do
    local dst="$HOME/$(basename $src)"
    link_file "$src" "$dst"
  done
}

link_file() {
  local src=$1
  local dst=$2
  local skip=x
  local overwrite=
  local backup=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then
    if [ "$overwrite_all" = "false" ] && [ "$backup_all" = "false" ] \
    && [ "$skip_all" = "false" ]; then
      local currentSrc=$(readlink $dst)

      if [ "$currentSrc" = "$src" ]; then
        skip=true
      else
        local msg1="File already exists: $dst, what do you want to do?\n\t"
        local msg2="[s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        user "$msg1$msg2"
        read -n 1 action
        echo ''

        case $action in
          o)
            overwrite=true
            ;;
          O)
            overwrite_all=true
            ;;
          b)
            backup=true
            ;;
          B)
            backup_all=true
            ;;
          s)
            skip=true
            ;;
          S)
            skip_all=true
            ;;
        esac
      fi
    fi

    overwrite="${overwrite:=$overwrite_all}"
    backup=${backup:=$backup_all}

    if [ $skip = "x" ]; then
      skip=$skip_all
    fi

    if [ $overwrite = "true" ]; then
      rm -rf "$dst"
      success "Removed $dst"
    fi

    if [ $backup = "true" ]; then
      mv "$dst" "$dst.bak"
      success "Moved $dst to $dst.bak"
    fi
  fi

  if [ $skip != "true" ]; then
    ln -s "$src" "$dst"
    success "$dst has been linked to $src"
  fi
}

configure
