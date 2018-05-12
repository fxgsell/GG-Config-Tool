# Jetson Configuration Utility

## Installation

The agent stays running all the time and waits for the Vol+ button to be double-pressed.

When the button is pressed it starts a web-ui with options to configure the Greengrass certificates and Wifi. 

    git clone https://github.com/zukoo/GG-Config-Tool.git
    cd GG-Config-Tool
    sudo ./install.sh

## Optional

Install dependencies to do ML @Edge like OpenCV and MXNet.

    cd scripts/tx2-setup-script/
    ./install.sh
