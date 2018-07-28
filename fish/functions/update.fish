function update --description 'Update software packages'
    sudo apt update
    sudo apt upgrade -y
    brew update
    brew upgrade
    vim +PluginUpdate
end
