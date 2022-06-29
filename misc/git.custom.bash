#!/bin/bash

# squash all commits into one (https://stackoverflow.com/a/47837371/137471)
alias git-squash-branch='git reset --soft HEAD~$(git rev-list --count HEAD ^master)'
alias git-branch-name='git rev-parse --abbrev-ref HEAD'
alias gc='git checkout'
alias pull='git pull --rebase'

# Displays git log with graph and colors
git-changes() {
    AUTHOR="--author `git config user.email`"
    if [ "$1" = "--all" ] ; then
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

# Creates a new branch with a (cleaned up) name based on an arbitrary string.
git-new-branch() {
    # use , as seperator to allow matching / in pattern
    new_branch_name=`echo $@ | sed -E 's,[^0-9a-zA-Zæøå /()_\-],_,g; s, ,_,g; s,_+,_,g'` &&
        git checkout -b "$new_branch_name"
}

# Cleans repo by removing *all* unversioned and ignored files. First, shows what will be cleaned, then asks for confirmation.
git-clean-all() {
  echo 'Clean would result in the following:' &&
    git clean -xdn &&
    echo '------------------------------------' &&
    read -p 'Continue with clean? (y/N): ' && [[ "$REPLY" = 'y' ]] &&
    git clean -xdf || echo 'Clean aborted.'
}

# Prepares local repo for review of a specific branch. Stores any uncommitted changes before checking out the latest version of the specified branch
review() {
    [[ -z "$1" ]] && echo 'Please specify a branch name to review.' || (
        git fetch origin "$1" &&
        git stash push -m "Stash before review of $1" &&
        git checkout "$1" &&
        git merge &&
        echo "Ready for review: $1")
}
