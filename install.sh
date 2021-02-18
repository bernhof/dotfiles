# NECESSITIES

# basic tools
sudo apt install curl -y
sudo apt install jq -y # command line json parser
sudo apt install cifs-utils smbclient -y # CIFS/samba tools
sudo apt install pavucontrol -y # PulseAudio Volume Control
sudo apt install openconnect -y

# docker
# https://docs.docker.com/engine/install/ubuntu/
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# not included in the guide:
sudo usermod -aG docker $USER

# docker compose (latest)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo dpkg -i /tmp/chrome.deb

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

# BASH-IT
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
git ~/.bash_it/install.sh --silent

bash-it enable plugin git sdkman
bash-it enable completion bash-it git gradle grails sdkman system

# Let all *custom.bash files be run at start of every terminal
source ~/.dotfiles/misc/custom.bash
copy-bash-it-custom

# 1Password
# https://app-updates.agilebits.com/product_history/CLI
wget https://cache.agilebits.com/dist/1P/op/pkg/v1.8.0/op_linux_amd64_v1.8.0.zip -O /tmp/op.zip
sudo unzip /tmp/op.zip -d /usr/local/bin/
gpg --recv-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22 #doesn't seem to work?
gpg --verify /usr/local/bin/op.sig /usr/local/bin/op

# Google Drive
# consider using gdrive, however currently there are issues with Google OAuth and gdrive
# - see https://github.com/gdrive-org/gdrive/issues/533
# - find latest at https://github.com/gdrive-org/gdrive#downloads

# ERST
source ~/.dotfiles/erst/erst.install.sh

echo "First-time sign-in to 1Password:"
op signin my bernhof@gmail.com

echo "End of install script"