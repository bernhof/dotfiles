echo "Laver ERST-specifik opsætning..."

# ERST
mkdir ~/src/erst -p

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

# Create .smbcredentials-erst file:
smbitemname="^ERST NC SMB$"
echo "username=$(op item get "$smbitemname" --fields username)
password=$(op item get "$smbitemname" --fields password)" >~/.smbcredentials-erst

# Add mounts:
echo "
//samba.nonprod.es.local/logs-nine /mnt/logs-nine cifs credentials=$HOME/.smbcredentials-erst,iocharset=utf8,sec=ntlmssp 0 0
//samba.nonprod.es.local/logs-all /mnt/logs-all cifs credentials=$HOME/.smbcredentials-erst,iocharset=utf8,sec=ntlmssp 0 0
//10.1.160.15/sector9  /mnt/sector9 cifs credentials=$HOME/.smbcredentials-erst,iocharset=utf8,sec=ntlmssp 0 0" | tee -a /etc/fstab