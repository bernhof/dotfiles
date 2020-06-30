# NECESSITIES

# basic tools
sudo apt install curl -y
sudo apt install jq -y #command line json parser
sudo apt install cifs-utils smbclient -y #CIFS/samba tools

# docker
# https://docs.docker.com/engine/install/ubuntu/
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo apt-key fingerprint 0EBFCD88
# NOTE: for 20.04 there's no "focal" distro yet, so using 19.04 (eoan)
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu eoan stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# not included in the guide:
sudo usermod -aG docker $USER

# docker compose (NOTE: version hardcoded)
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
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

# sdkman
curl -s "https://get.sdkman.io" | bash
source ~/.sdkman/bin/sdkman-init.sh

# Disable Alt+F1 shortcut for home view (clashes with the "Select In..." shortcut in IDEA on Visual Studio key scheme)
KEYBINDINGS=$(gsettings get org.gnome.desktop.wm.keybindings panel-main-menu | sed "s/\(, \)\?'<Alt>F1'//")
gsettings set org.gnome.desktop.wm.keybindings panel-main-menu $KEYBINDINGS

# Disable Alt+F5 shortcut for unmaximize (clashes with "Debug Test" shortcut in IDEA on Visual Studio key scheme)
KEYBINDINGS=$(gsettings get org.gnome.desktop.wm.keybindings unmaximize | sed "s/\(, \)\?'<Alt>F5'//")
gsettings set org.gnome.desktop.wm.keybindings unmaximize $KEYBINDINGS

# Show week no. in GNOME calendar
gsettings set org.gnome.desktop.calendar show-weekdate true


# NINE

# Google Drive
# consider using gdrive, however currently there are issues with Google OAuth and gdrive
# - see https://github.com/gdrive-org/gdrive/issues/533
# - find latest at https://github.com/gdrive-org/gdrive#downloads

# EXTRAS
sudo snap install spotify

# BASH-IT
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
git ~/.bash_it/install.sh --silent

bash-it enable plugin git sdkman
bash-it enable completion bash-it git gradle grails sdkman system

source misc/custom.aliases.bash
copy-bash-it-custom

# 1Password
# https://app-updates.agilebits.com/product_history/CLI
wget https://cache.agilebits.com/dist/1P/op/pkg/v1.0.0/op_linux_amd64_v1.0.0.zip -0 /tmp/op.zip
unzip /tmp/op.zip -d /usr/local/bin/
gpg --recv-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22 #doesn't seem to work?
gpg --verify /usr/local/bin/op.sig /usr/local/bin/op

# ERST
source erst/erst.install.sh