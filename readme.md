# Mikkel's dotfiles

Uses [bash-it](https://github.com/bash-it/bash-it) for shell customization.

## 1. First things first

    sudo apt update
    sudo apt install -y git
    git clone https://github.com/bernhof/dotfiles ~/.dotfiles
    source ~/.dotfiles/install.sh

## 2. Manual steps required

* In Chrome: Set up profiles and sign in to Google accounts
* [Google Drive](https://drive.google.com): Download user home data

## 3. Enable commits to this repository

    cd ~/.dotfiles
    git remote remove origin
    git remote add origin git@github.com:bernhof/dotfiles.git

## 4. Restart

    shutdown -r now

# Thanks to

* [@brianjohnsen](https://github.com/brianjohnsen) for help and his [dotfiles](https://github.com/brianjohnsen/dotfiles) repo for inspiration.
* [demmer/git-scripts](https://github.com/demmer/git-scripts) for some useful git scripts
