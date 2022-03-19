echo "Laver ERST-specifik opsætning..."

# ERST
mkdir ~/src/erst -p

#sudo snap install teams # pt. fungerer Teams bedre direkte i Chrome

sdk install java 8.0.265-open

# Install redis:
sudo apt install make clang -y # allows building redis-cli from source
make distclean                 # avoids build errors

# Source: https://codewithhugo.com/install-just-redis-cli-on-ubuntu-debian-jessie/
cd /tmp
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
sudo cp src/redis-cli /usr/local/bin/
sudo chmod 755 /usr/local/bin/redis-cli
cd ~

google-chrome https://github.com/kaikramer/keystore-explorer/releases/latest # Ikke pt. tilgængelig som pakke på apt/snap
