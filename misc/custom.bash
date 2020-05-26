# COPY
# cp -v ~/.dotfiles/misc/custom.bash ~/.bash_it/custom/

# Bash-it theme w/o clock emoji
export BASH_IT_THEME=bobby
export THEME_SHOW_CLOCK_CHAR=false
export DOTFILES=~/.dotfiles/

# Bash-It:
copy-bash-it-custom() {
    rm ~/.bash_it/custom/*custom.bash
    cp -v $(find $DOTFILES -name *custom.bash) ~/.bash_it/custom/
    cp -v ${DOTFILES}misc/custom.aliases.bash ~/.bash_it/aliases/
    source ~/.bashrc
}

trim() {
    sed -E "s/^$1|$1$//g"
}

ltrim() {
    sed -E "s/^$1//g"
}

rtrim() {
    sed -E "s/$1$//g"
}