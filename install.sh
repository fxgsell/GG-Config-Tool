#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

rm -rf /opt/gg-config-ui/
mkdir -p /opt/gg-config-ui/
cp -r ./* /opt/gg-config-ui/

echo "[Unit]
Description=gg-config-ui daemon
After=network.target

[Service]
WorkingDirectory=/opt/gg-config-ui/
ExecStart=/opt/gg-config-ui/start.sh
Type=simple
RestartSec=2
Restart=always
User=root
PIDFile=/var/run/gg-config-ui.pid

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/gg-config-ui.service

sudo systemctl enable gg-config-ui

mkdir -p /opt/gg-config-ui/binaries/
cd /opt/gg-config-ui/binaries/

curl -O https://s3.amazonaws.com/fx-greengrass-models/binaries/greengrass-linux-aarch64-1.5.0.tar.gz || exit
curl -o root.ca.pem http://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem || exit

sudo systemctl restart gg-config-ui
