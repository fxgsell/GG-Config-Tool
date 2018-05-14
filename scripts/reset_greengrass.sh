#!/bin/bash

BINARIES=/opt/gg-config-ui/binaries/

[ -s uploads/configuration.tar.gz ] || exit

cp uploads/configuration.tar.gz /tmp/configuration.tar.gz

# Validate certificates here - TODO
#
# 1. Valid tar.gz
# 2. Size range is appropriate
# 3. All the files are inside
# 4. Individual size is appropriate


systemctl stop greengrass

pkill greengrass
pkill -9 greengrass

rm -rf /greengrass
tar -xzvf $BINARIES/greengrass-linux-aarch64-1.5.0.tar.gz -C /
tar -xzvf uploads/certificates.tar.gz -C /greengrass
cp $BINARIES/root.ca.pem /greengrass/certs/root.ca.pem

systemctl start greengrass
systemctl status greengrass