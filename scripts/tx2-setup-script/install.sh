#!/bin/bash

# Use after Clean JetPack 3.2 install

#TODO: 
# Pre-build OpenCV
# Copy in S3 all external links

# Prerequisits 
sudo apt update
sudo apt install -y --allow-unauthenticated  libcudnn7 libcudnn7-dev
sudo apt dist-upgrade -y
sudo apt install -y htop screen mplayer curl
sudo apt remove -y lightdm*
sudo apt remove -y network-manager* 

sudo echo '' | sudo tee -a /etc/network/interfaces
sudo echo 'auto eth0' | sudo tee -a /etc/network/interfaces
sudo echo 'iface eth0 inet dhcp' | sudo tee -a /etc/network/interfaces

sudo systemctl enable networking

sudo adduser --system ggc_user
sudo addgroup --system ggc_group

git clone https://github.com/aws-samples/aws-greengrass-samples.git || exit
cd aws-greengrass-samples
cd greengrass-dependency-checker-GGCv1.5.0
sudo ./check_ggc_dependencies || exit

# MXNet 
curl -O https://s3.amazonaws.com/fx-greengrass-models/binaries/mxnet-1.2.0-py2.py3-none-any.whl || exit
sudo su -c "pip install -e ./mxnet-1.2.0-py2.py3-none-any.whl" || exit

# Greengrass service

echo "[Unit]
Description=greengrass daemon
After=network.target

[Service]
ExecStart=/greengrass/ggc/core/greengrassd start
Type=simple
RestartSec=2
Restart=always
User=root
PIDFile=/var/run/greengrassd.pid

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/greengrass.service

sudo systemctl enable greengrass

# OpenCV
sudo apt remove -y libopencv || exit
git clone https://github.com/jetsonhacks/buildOpenCVTX2.git || exit
cd buildOpenCVTX2/
./buildOpenCV.sh
cd $HOME/opencv/build
make
sudo make install
