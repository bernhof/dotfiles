# COPY
# cp -v ~/.dotfiles/misc/custom.aliases.bash ~/.bash_it/aliases/

# squash all commits into one (https://stackoverflow.com/a/47837371/137471)
alias gisquash='git reset --soft HEAD~$(git rev-list --count HEAD ^master)'