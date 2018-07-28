add_to_vbox_group() {
  if is_vbox; then
    local vbox_grp=vboxsf
    if !(groups | grep -q $vbox_grp); then
      sudo usermod -aG $vbox_grp $(whoami)
      success "$USER is now a part of the group '$vbox_grp'"
    fi
  fi
}
