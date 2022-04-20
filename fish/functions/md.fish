function md --description 'Creates a directory and then switches to it.'
    mkdir -p $argv[1] && cd $argv[1]
end
