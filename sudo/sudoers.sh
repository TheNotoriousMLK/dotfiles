set_sudoers() {
  if is_linux; then
    local apt=$(which apt)
    local apt_get=$(which apt-get)
    local snap=$(which snap)

    local opt="$USER ALL=(ALL) NOPASSWD:$apt,$apt_get,$snap"

    if !(sudo -E cat /etc/sudoers | grep -q "^$opt\$"); then
      info 'Backing up /etc/sudoers to /etc/sudoers.bak'
      sudo cp /etc/sudoers /etc/sudoers.bak
      info 'Updating /etc/sudoers'
      sudo cat /etc/sudoers > tmp
      echo -e "\n$opt" >> tmp
      sudo chown root:root tmp
      sudo chmod 440 tmp
      sudo mv tmp /etc/sudoers
      sudo visudo -c
      success 'Sudoers has been updated'
    fi
  fi
}
