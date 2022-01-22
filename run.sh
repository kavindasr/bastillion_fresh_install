#!/bin/bash

# install openjdk
sudo apt install default-jre

# install wget
sudo apt install wget
 
# download bastillion(v3.08.01) tar
wget https://github.com/bastillion-io/Bastillion/releases/download/v3.08.01/bastillion-jetty-v3.08_01.tar.gz

# unzip the tar to a tempory location
tar xvf bastillion-jetty-v3.08_01.tar.gz

# move folder to the /usr/lib
sudo mv Bastillion-jetty/ /usr/lib/

# intall ufw
sudo apt install ufw

# allowing default settings
sudo ufw default deny incoming
sudo ufw default allow outgoing

# allwoing 8443 port
sudo ufw allow 8443

# allow ssh port
sudo ufw allow OpenSSH

sudo ufw enable

# create systemd service
echo "[Unit]
Description=Bastion host
After=syslog.target

[Service]
WorkingDirectory=/usr/lib/Bastillion-jetty/
ExecStart=/usr/lib/Bastillion-jetty/startBastillion.sh
SuccessExitStatus=143
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target">>bastillion.service

# move to systemd/system
sudo mv bastillion.service /etc/systemd/system/

# enable the service
sudo systemctl enable bastillion.service

# Setup db password
cd /usr/lib/Bastillion-jetty/
./startBastillion.sh

echo "Terminate the shell and run 'sudo systemctl start bastillion.service'"
# start the service
# sudo systemctl start bastillion.service
