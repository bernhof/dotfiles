# ERST
mkdir ~/src/erst -p

sudo snap install teams

sdk install java 8.0.265-open

# See also: http://confluence/display/MIT/Kom+Godt+I+Gang+Som+Udvikler
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Docker setup, see http://confluence/pages/viewpage.action?pageId=36241500

sudo sed -i 's/ExecStart=\/usr\/bin\/dockerd -H fd:\/\//ExecStart=\/usr\/bin\/dockerd/' /lib/systemd/system/docker.service
# WARNING: this overwrites any existing config entirely (there shouldn't be one initially, though)
echo '{ "bip": "10.20.0.1/16", "hosts": ["tcp://127.0.0.1:2375"] }' | sudo tee /etc/docker/daemon.json

sudo systemctl daemon-reload
sudo service docker restart

sudo apt install make clang -y # allows building redis-cli from source
make distclean # avoids build errors
# Install redis-cli (https://codewithhugo.com/install-just-redis-cli-on-ubuntu-debian-jessie/)
cd /tmp
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
sudo cp src/redis-cli /usr/local/bin/
sudo chmod 755 /usr/local/bin/redis-cli
cd ~