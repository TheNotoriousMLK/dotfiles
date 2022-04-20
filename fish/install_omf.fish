#!/usr/local/bin/fish

function install_omf
  if ! type omf > /dev/null 2>&1
    curl -L https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
    omf install > /dev/null 2>&1
  end
end

install_omf
