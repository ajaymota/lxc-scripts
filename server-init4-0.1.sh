# Script for deployment of first full ciro system
# including parts of Guacamole, LXC, Tomcat, MySQL and web panels
# 
#					Copyright 2016
# 				Ajay Mota, Global Tech LLP.
#

#!/bin/sh -e

# LVM setup 1
sudo pvcreate /dev/sdb1

# LVM setup 2
sudo vgcreate lxc /dev/sdb1

# Install LXC
sudo apt-get install cgmanager lxc

# Add lxc-usernet
sudo echo "admin veth lxcbr0 10" >> /etc/lxc/lxc-usernet

# LXC related usernet config
mkdir -p ~/.config/lxc
cp /etc/lxc/default.conf ~/.config/lxc/default.conf
echo "lxc.id_map = u 0 100000 65536" >> ~/.config/lxc/default.conf
echo "lxc.id_map = g 0 100000 65536" >> ~/.config/lxc/default.conf
