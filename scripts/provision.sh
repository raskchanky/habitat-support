#!/bin/bash

cd /src
cp components/hab/install.sh /tmp/
sh support/linux/install_dev_0_ubuntu_latest.sh
sh support/linux/install_dev_9_linux.sh
. ~/.profile
make

# We do this because we need this package installed before we can mess with the config,
# which we need to do in order to mess with certain values that aren't exposed in the core
# package. (Note to self: Add them to the core package.)
hab pkg install core/postgresql --url https://bldr.habitat.sh/v1/depot
cat /config/postgresql.conf  >> "$(hab pkg path core/postgresql)/config/postgresql.conf"

echo 'source /scripts/env.sh' >> ~/.bashrc

cd /src
make clean build-srv
