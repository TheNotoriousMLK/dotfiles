#!/usr/local/bin/fish

function install_omf
  if ! type omf > /dev/null 2>&1
    curl -L https://get.oh-my.fish > /dev/null 2>&1 | fish > /dev/null 2>&1
    omf install > /dev/null 2>&1
  end
end

install_omf
