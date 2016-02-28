# Script for deployment of first full ciro system
# including parts of Guacamole, LXC, Tomcat, MySQL and web panels
# 
#					Copyright 2016
# 				Ajay Mota, Global Tech LLP.
#

#!/bin/sh -e

# Installing required apache2 packages
sudo apt-get -y install libapache2-mod-proxy-html
sudo a2enmod proxy_wstunnel

# Restart apache2 service
sudo service apache2 restart

# Proxying Tomcat with apache2 for Guacamole support
# Append lines to apache config
echo "" >> /etc/apache2.conf
echo "# Tomcat proxy for guacamole" >> /etc/apache2.conf
echo "<Location /guacamole/>" >> /etc/apache2/apache2.conf
echo "    Order allow,deny" >> /etc/apache2/apache2.conf
echo "    Allow from all" >> /etc/apache2/apache2.conf
echo "    ProxyPass http://localhost:8080/guacamole/ flushpackets=on" >> /etc/apache2/apache2.conf
echo "    ProxyPassReverse http://localhost:8080/guacamole/" >> /etc/apache2/apache2.conf
echo "</Location>" >> /etc/apache2/apache2.conf

echo "" >> /etc/apache2.conf
echo "<Location /guacamole/websocket-tunnel>" >> /etc/apache2/apache2.conf
echo "    Order allow,deny" >> /etc/apache2/apache2.conf
echo "    Allow from all" >> /etc/apache2/apache2.conf
echo "    ProxyPass ws://localhost:8080/guacamole/websocket-tunnel flushpackets=on" >> /etc/apache2/apache2.conf
echo "    ProxyPassReverse ws://localhost:8080/guacamole/websocket-tunnel" >> /etc/apache2/apache2.conf
echo "</Location>" >> /etc/apache2/apache2.conf


# Restart apache2 service
sudo service apache2 restart

# Restart Tomcat7 service
sudo service tomcat7 restart
