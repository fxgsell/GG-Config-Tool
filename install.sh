#!/bin/bash

optspec=":h-:"
DEPENDENCIES=0
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                no-dependencies)
                    DEPENDENCIES=1
                    ;;
            esac;;
        h)
            echo "usage: $0 [--no-dependencies]" >&2
            exit 2
            ;;
    esac
done

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [ $DEPENDENCIES -ne 1 ]; then
    if ! grep -Fxq "timestamp_timeout" /etc/sudoers
    then
        echo "\nDefaults timestamp_timeout=-1" >> /etc/sudoers
    fi
  echo "Intalling dependencies"
  cd scripts/tx2-setup-script/
  sudo -H -u nvidia ./install.sh
fi

echo "Cleaning existing installation"
rm -rf /opt/gg-config-ui/

echo "Copying files"
mkdir -p /opt/gg-config-ui/binaries/

cp -rv ./* /opt/gg-config-ui/

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
WantedBy=multi-user.target" | tee /etc/systemd/system/gg-config-ui.service

systemctl enable gg-config-ui

cd /opt/gg-config-ui/binaries/

curl -O https://s3.amazonaws.com/fx-greengrass-models/binaries/greengrass-linux-aarch64-1.5.0.tar.gz || exit
curl -o root.ca.pem http://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem || exit

systemctl restart gg-config-ui

CRON='@reboot python /opt/gg-config-ui/reboot.sh'

grep -q -F "$CRON" /etc/crontab || echo "$CRON" >> /etc/crontab

