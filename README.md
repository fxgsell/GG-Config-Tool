# Jetson Configuration Utility

## Prerequists

Install the device with JetPack 3.2 and log-in as *nvidia*. Make sure to uncheck OpenCV from the configuration.

![Jetson configuration][screenshot]

[screenshot]: ./static/images/jetson_config.png "Jetson configuration"

## Installation

The agent stays running all the time and waits for the Vol+ button to be double-pressed.

When the button is pressed it starts a web-ui with options to configure the Greengrass certificates and Wifi.

    git clone https://github.com/zukoo/GG-Config-Tool.git
    cd GG-Config-Tool
    sudo ./install.sh

## Optionally

You can install the agent without the dependencies for ML @Edge like OpenCV and MXNet.

    sudo ./install.sh --no-dependencies
