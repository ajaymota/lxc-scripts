# Script for deployment of first full ciro system
# including parts of Guacamole, LXC, Tomcat, MySQL and web panels
# 
#					Copyright 2016
# 				Ajay Mota, ANJ Tech LLP.
#

#!/bin/sh -e

# Create instance
#sudo lxc-create -t download -n u0 -B lvm --fssize=100G -- --dist ubuntu --release trusty --arch amd64
sudo lxc-create -t download -n u_lxde -- --dist ubuntu --release trusty --arch amd64

# Start instance
sudo lxc-start -n u_lxde -d

# Boot into LXC Container
sudo lxc-attach -n u_lxde

# Following commands in LXC
# Creating the non-root admin user
useradd -c "Default User" -m default -s /bin/bash

# Setting admin password
echo -e "default\ndefault" | passwd default

# Installing certain dependencies and packages
apt-get update

# Adding user admin to sudo-ers group
gpasswd -a default sudo

# Change to default user
su - default

# Following commands in LXC again
## Mate install services
#sudo apt-get install software-properties-common
#sudo apt-add-repository ppa:ubuntu-mate-dev/ppa
#sudo apt-add-repository ppa:ubuntu-mate-dev/trusty-mate
#sudo apt-get update
#sudo apt-get install ubuntu-mate-core ubuntu-mate-desktop

# Install ubuntu classic desktop
#sudo apt-get install nano ubuntu-desktop \
#	gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal 
sudo apt-get -y install nano lubuntu-desktop
