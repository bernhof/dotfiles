# squash all commits into one (https://stackoverflow.com/a/47837371/137471)
alias git-squash='git reset --soft HEAD~$(git rev-list --count HEAD ^master)'
alias git-branch-name='git rev-parse --abbrev-ref HEAD'

# Displays git log with graph and colors
git-changes() {
    AUTHOR="--author `git config user.email`"
    if [ "$1" == "--all" ] ; then
        AUTHOR=""
    fi

    git log master..$gitbranchname $AUTHOR --oneline --graph --pretty=format:'%C(yellow)%h%Creset - %Cblue[%an]%Creset: %s %Cgreen(%ar)%Creset'
}

# Displays diff against base
git-diff-base() {
    if [ -z $MASTER ] ; then
        MASTER=master
    fi

    git diff $* `git merge-base HEAD $MASTER` HEAD
}

# Simple script that cleans up unnecessary branches.
#
# First it deletes each fully merged branch after prompting
# for confirmation.
#
# Then it prunes all branches that no longer exist at each upstream
# remote.
git-prune-branches() {
    merged=`git branch --no-color --merged master | grep -v master | sed 's/\*/ /'`

    if [ ! -z "$merged" ] ; then
        echo "Deleting the following merged branches:"
        for branch in $merged ; do
        echo "    " $branch
        done

        all=n
        delete=n
        for branch in $merged ; do
        if [ $all = 'n' ] ; then
                delete=n
                read -p "Delete $branch (y=yes, n=no, a=all)? " prompt
            echo "all=$all delete=$delete prompt=$prompt"
                if [ "$prompt" = 'a' ] ; then
            delete=y
            all=y
            elif [ "$prompt" = 'y' ]; then
            delete=y
            fi
        fi

        if [ "$delete" = 'y' ] ; then
            git branch -d $branch
        fi
        done
    fi
            
    remotes=`git remote`
    for remote in $remotes ; do
        prompt=n
        read -p "Prune deleted branches from remote '$remote' (y=yes n=no)? " prompt
        if [ "$prompt" = 'y' ] ; then
        git remote prune $remote
        fi
    done
}