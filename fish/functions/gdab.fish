function gdab --description 'Delete all local merged branches while excluding master or main'
    for branch in (git for-each-ref --format '%(refname:short)' --merged HEAD refs/heads/ | grep -v 'master\|main')
        git branch -d $branch
    end
end
