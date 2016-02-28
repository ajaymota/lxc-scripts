# Script for deployment of first full ciro system
# including parts of Guacamole, LXC, Tomcat, MySQL and web panels
# 
#					Copyright 2016
# 				Ajay Mota, Global Tech LLP.
#

#!/bin/sh -e

# Installing basic requirements and packages
apt-get update && apt-get -y install tomcat7 libcairo2-dev libpng12-dev libossp-uuid-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libpulse-dev libssl-dev libvorbis-dev libwebp-dev

# Add GUACAMOLE_HOME to Tomcat7 ENV
echo "" >> /etc/default/tomcat7
echo "# GUACAMOLE EVN VARIABLE" >> /etc/default/tomcat7
echo "GUACAMOLE_HOME=/etc/guacamole" >> /etc/default/tomcat7


# Install libjpeg-turbo-dev
wget -O libjpeg-turbo-official_1.4.2_amd64.deb http://downloads.sourceforge.net/project/libjpeg-turbo/1.4.2/libjpeg-turbo-official_1.4.2_amd64.deb
dpkg -i libjpeg-turbo-official_1.4.2_amd64.deb

#Download Guacamole Files
wget -O guacamole-0.9.9.war http://downloads.sourceforge.net/project/guacamole/current/binary/guacamole-0.9.9.war
wget -O guacamole-server-0.9.9.tar.gz http://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-0.9.9.tar.gz

#Extract Guac
tar -xzf guacamole-server-0.9.9.tar.gz

# MAKE DIRECTORIES
mkdir /etc/guacamole

# Install GUACD
cd guacamole-server-0.9.9
./configure --with-init-dir=/etc/init.d
make
make install
ldconfig
update-rc.d guacd defaults
cd ..

# Move files to correct locations
mv guacamole-0.9.9.war /etc/guacamole/guacamole.war
ln -s /etc/guacamole/guacamole.war /var/lib/tomcat7/webapps/

# Configure guacamole.properties
echo "# Hostname and port of guacamole proxy" >> /etc/guacamole/guacamole.properties
echo "guacd-hostname: localhost" >> /etc/guacamole/guacamole.properties
echo "guacd-port:     4822" >> /etc/guacamole/guacamole.properties

# Configure user-mapping.xml
echo "<user-mapping>" >> /etc/guacamole/user-mapping.xml
echo "" >> /etc/guacamole/user-mapping.xml
echo "    <!-- Per-user authentication and config information -->" >> /etc/guacamole/user-mapping.xml
echo "    <authorize username="admin" password="f1aa2du3">" >> /etc/guacamole/user-mapping.xml
echo "        <protocol>vnc</protocol>" >> /etc/guacamole/user-mapping.xml
echo "        <param name="hostname">176.9.154.6</param>" >> /etc/guacamole/user-mapping.xml
echo "        <param name="port">5901</param>" >> /etc/guacamole/user-mapping.xml
echo "        <param name="password">password</param>" >> /etc/guacamole/user-mapping.xml
echo "    </authorize>" >> /etc/guacamole/user-mapping.xml
echo "" >> /etc/guacamole/user-mapping.xml
echo "</user-mapping>" >> /etc/guacamole/user-mapping.xml

# Restart Tomcat Service
service tomcat7 restart

# Cleanup Downloads
rm libjpeg-turbo-official_1.4.2_amd64.deb
rm guacamole-server-0.9.9.tar.gz

# Cleanup Folders
rm -rf guacamole-server-0.9.9/
