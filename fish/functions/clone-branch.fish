function clone-branch --description 'Clones a single branch from a git repo.'
    git clone -b $argv[1] --single-branch $argv[2]
end
