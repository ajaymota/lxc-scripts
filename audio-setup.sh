# Script for deployment of first full ciro system
# including parts of Guacamole, LXC, Tomcat, MySQL and web panels
# 
#					Copyright 2016
# 				Ajay Mota, ANJ Tech LLP.
#

#!/bin/sh -e

## Commands on host system
sudo apt-get -y install libasound2 libasound2-plugins alsa-utils alsa-oss
sudo apt-get -y install pulseaudio pulseaudio-utils
sudo apt-get -y install pulseaudio pulseaudio-module-zeroconf avahi-daemon dbus-x11
sudo apt-get -y install pulseaudio libcanberra-pulse pulseaudio-module-zeroconf paprefs pavucontrol alsa alsa-utils 

# PulseAudio setup for port listening
echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;10.0.3.0/24 auth-anonymous=1" |  sudo tee -a /etc/pulse/system.pa 
echo "load-module module-zeroconf-publish"  | sudo tee -a /etc/pulse/system.pa 

## Commands inside the LXC Container
# Set permissions
#sudo usermod -aG pulse,pulse-access <username>
sudo usermod -aG pulse,pulse-access,audio default

# load server on user start
echo "export PULSE_SERVER=10.0.3.1" | tee -a ~/.bashrc

## Commands in host system
# NOTE: Don't forget to edit guacamole/user-mapping.xml
# Restart PulseAudio server
sudo service pulseaudio restart

## Some documentation for audio :-
# 1. Edit the host /etc/pulse/system.pa to enable guacamole
# 2. Run pulseaudio service as root and daemon
# 3. And then do this -
sudo usermod -aG pulse,pulse-access,audio root
sudo service pulseaudio restart

# For LXC container :-
# 1. Edit /root/.bashrc to enable PULSE_SERVER=10.0.3.1
# 2. Run pulseaudio service as root and daemon
# 3. And then do this -
sudo usermod -aG pulse,pulse-access,audio root
sudo service pulseaudio restart

