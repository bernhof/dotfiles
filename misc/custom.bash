# Bash-it theme w/o clock emoji
export BASH_IT_THEME=bobby
export THEME_SHOW_CLOCK_CHAR=false
export DOTFILES=~/.dotfiles/
export PATH=$PATH:$HOME/go/bin:$HOME/scripts:/usr/local/go/bin

# Bash-It:
copy-bash-it-custom() {
  rm ~/.bash_it/custom/*custom.bash
  for f in "${DOTFILES}"**/*custom.bash; do
      cp -v "$f" ~/.bash_it/custom/
  done
  cp -v "${DOTFILES}misc/custom.aliases.bash" ~/.bash_it/aliases/
  cp -v "${DOTFILES}home/.bash_completion" ~/.bash_completion
  # https://github.com/cykerway/complete-alias:
  cp -v "${DOTFILES}home/.complete_alias" ~/.complete_alias
  bashit reload
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

# Removes all disabled (inactive) snap versions from the system.
# Can free up space significantly
snap-prune-versions() {
  LANG=en_US.UTF-8
  snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
      sudo snap remove "$snapname" --revision="$revision"
    done
}

show-free-space() {
  df -Th | grep -v fs
}

# source: https://askubuntu.com/a/1161181/1078101
free-up-space() {
  show-free-space

  # Will need English output for processing
  LANG=en_GB.UTF-8

  ## Clean apt cache
  sudo apt-get update
  sudo apt-get -f install
  sudo apt-get -y autoremove
  sudo apt-get clean

  ## Remove old versions of snap packages
  snap-prune-versions

  ## Set snap versions retain settings
  if [[ $(snap get system refresh.retain) -ne 2 ]]; then sudo snap set system refresh.retain=2; fi
  sudo rm -f /var/lib/snapd/cache/*

  ## Rotate and delete old logs
  /etc/cron.daily/logrotate
  sudo find /var/log -type f -iname *.gz -delete
  sudo journalctl --rotate
  sudo journalctl --vacuum-time=1s

  show-free-space
}
