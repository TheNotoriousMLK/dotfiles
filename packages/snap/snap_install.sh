source $SNAP_DIR/snap_funcs.sh

snap_install() {
  local pkgs=(`cat $SNAP_DIR/packages.txt`)

  snap_add_pkgs "${pkgs[@]}"
}
