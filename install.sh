#!/bin/bash

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
sudo systemctl start gg-config-ui