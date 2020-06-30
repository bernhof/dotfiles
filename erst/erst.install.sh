# ERST
mkdir ~/src/erst

sdk install java 8.0.252-open
sdk install groovy 2.5.11
sdk install grails 3.3.11

# See also: http://confluence/display/MIT/Kom+Godt+I+Gang+Som+Udvikler
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Docker setup, see http://confluence/pages/viewpage.action?pageId=36241500

sudo sed -i 's/ExecStart=\/usr\/bin\/dockerd -H fd:\/\//ExecStart=\/usr\/bin\/dockerd/' /lib/systemd/system/docker.service
# WARNING: this overwrites any existing config entirely (there shouldn't be one initially, though)
echo '{ "bip": "10.20.0.1/16", "hosts": ["tcp://127.0.0.1:2375"] }' | sudo tee /etc/docker/daemon.json

sudo systemctl daemon-reload
sudo service docker restart
