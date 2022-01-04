#!/bin/bash

# NECESSITIES

# basic tools
sudo apt update
sudo apt -y upgrade
sudo apt install curl -y
sudo apt install jq -y                   # command line json parser
sudo apt install cifs-utils smbclient -y # CIFS/samba tools
sudo apt install pavucontrol -y          # PulseAudio Volume Control
sudo apt install openconnect -y          # OpenConnect VPN client
sudo apt install meld -y                 # Meld diff tool
#sudo apt install golang -y # Golang is outdated here, is installed manually instead, see below

# BASH-IT
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
git ~/.bash_it/install.sh --silent

bash-it enable plugin git sdkman
bash-it enable completion bash-it git gradle grails sdkman system kubectl

# Let all *custom.bash files be run at start of every terminal
source ~/.dotfiles/misc/custom.bash
copy-bash-it-custom

# docker
# https://docs.docker.com/engine/install/ubuntu/
sudo apt-get install apt-transport-https ca-certificates curl gnupg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# not included in the guide:
sudo usermod -aG docker $USER

# docker compose (latest)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# golang (mainly to enable "go install" command)
# see https://go.dev/doc/install for latest binary version
wget https://go.dev/dl/go1.17.5.linux-amd64.tar.gz -O /tmp/go.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go.tar.gz

# kind
# https://kind.sigs.k8s.io/docs/user/quick-start with modifications:
go install -v sigs.k8s.io/kind@latest

# kubectl
sudo snap install kubectl --classic

# google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo dpkg -i /tmp/chrome.deb

# drive (cmdline for Google Drive)
go install -v github.com/odeke-em/drive/cmd/drive@latest # (can take a while)

# vscode
sudo snap install code --classic
#code --install-extension mechatroner.rainbow-csv

# slack
sudo snap install slack --classic

# JAVA DEV ENVIRONMENT
sudo snap install intellij-idea-ultimate --classic
sudo snap alias intellij-idea-ultimate idea

# sdkman
curl -s "https://get.sdkman.io" | bash
source ~/.sdkman/bin/sdkman-init.sh
# automatically apply .sdkmanrc environment definitions:
sed -i "s/sdkman_auto_env=false/sdkman_auto_env=true/g" ~/.sdkman/etc/config

# Disable Alt+F1 shortcut for home view (clashes with the "Select In..." shortcut in IDEA on Visual Studio key scheme)
KEYBINDINGS=$(gsettings get org.gnome.desktop.wm.keybindings panel-main-menu | sed "s/\(, \)\?'<Alt>F1'//")
gsettings set org.gnome.desktop.wm.keybindings panel-main-menu $KEYBINDINGS

# Disable Alt+F5 shortcut for unmaximize (clashes with "Debug Test" shortcut in IDEA on Visual Studio key scheme)
KEYBINDINGS=$(gsettings get org.gnome.desktop.wm.keybindings unmaximize | sed "s/\(, \)\?'<Alt>F5'//")
gsettings set org.gnome.desktop.wm.keybindings unmaximize $KEYBINDINGS

# Show week no. in GNOME calendar
gsettings set org.gnome.desktop.calendar show-weekdate true
# Use English language, Danish formats
gsettings set org.gnome.system.locale region 'en_DK.UTF-8'

# EXTRAS
sudo snap install spotify

# ADDITIONAL INSTALL SCRIPTS
source ~/.dotfiles/install.dell-precision-5550.bash

# 1Password CLI
# https://app-updates.agilebits.com/product_history/CLI
wget https://cache.agilebits.com/dist/1P/op/pkg/v1.12.2/op_linux_amd64_v1.12.2.zip -O /tmp/op.zip
sudo unzip /tmp/op.zip -d /usr/local/bin/
gpg --recv-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22 #doesn't seem to work?
gpg --verify /usr/local/bin/op.sig /usr/local/bin/op

# 1Password desktop client
# https://support.1password.com/install-linux/
 curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
 echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
 sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
 curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
 sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
 curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
sudo apt update && sudo apt install 1password

# Google Drive
# consider using gdrive, however currently there are issues with Google OAuth and gdrive
# - see https://github.com/gdrive-org/gdrive/issues/533
# - find latest at https://github.com/gdrive-org/gdrive#downloads

# ERST
source ~/.dotfiles/erst/erst.install.sh

echo "First-time sign-in to 1Password: (will keep retrying until sign-in succeeds; press CTRL+C to abort)" &&
  while [ -z "$OP_SESSION_my" ]; do
    eval $(op signin my bernhof@gmail.com)
  done

# Setup .smbcredentials
smbitemname="^ERST NC SMB$"
echo "username=$(opfield "$smbitemname" username)
password=$(opfield "$smbitemname" password)" >~/.smbcredentials-erst

echo "(End of install script)"
