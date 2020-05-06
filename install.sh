# basic tools
sudo apt install curl -y

# google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo dpkg -i /tmp/chrome.deb

# vscode
sudo snap install code --classic
sudo snap install slack --classic

# NINE

# Google Drive
# consider using gdrive, however currently there are issues with Google OAuth and gdrive
# - see https://github.com/gdrive-org/gdrive/issues/533
# - find latest at https://github.com/gdrive-org/gdrive#downloads
# instead, simply open browser
google-chrome https://drive.google.com/drive/u/0/folders/1xVELV9XDb2jMoPClLHgAiq1azkppzvbR

# JAVA DEV ENVIRONMENT

# sdkman
sudo snap install intellij-idea-ultimate --classic
curl -s "https://get.sdkman.io" | bash
source ~/.sdkman/bin/sdkman-init.sh

# ERST
sdk install java 8.0.252-open
sdk install groovy 2.5.11
sdk install grails 3.3.11

# See also: http://confluence/display/MIT/Kom+Godt+I+Gang+Som+Udvikler
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Forbind til ERST VPN
#sudo apt install openconnect -y
#sudo openconnect vpn.erst.dk