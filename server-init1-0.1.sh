# Initial server script for initializing users, security, etc.
# 
#					Copyright 2016
# 				Ajay Mota, Global Tech LLP.
#

#!/bin/sh -e

# Creating the non-root admin user
useradd -c "System Admin" -m admin -s /bin/bash

# Setting admin password
echo -e "faadu123\nfaadu123" | passwd admin

# Installing certain dependencies and packages
apt-get update && apt-get -y install sudo gpasswd

# Adding user admin to sudo-ers group
gpasswd -a admin sudo
