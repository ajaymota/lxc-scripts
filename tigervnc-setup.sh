# Script for deployment of first full ciro system
# including parts of Guacamole, LXC, Tomcat, MySQL and web panels
# 
#					Copyright 2016
# 				Ajay Mota, ANJ Tech LLP.
#

#!/bin/sh -e

# All commands inside lxc
# Install tigervnc and deps
## libjpeg-turbo
wget -O libjpeg-turbo-official_1.4.2_amd64.deb http://downloads.sourceforge.net/project/libjpeg-turbo/1.4.2/libjpeg-turbo-official_1.4.2_amd64.deb
sudo dpkg -i libjpeg-turbo-official_1.4.2_amd64.deb

## TigerVNC
wget -O tigervncserver_1.6.0-3ubuntu1_amd64.deb --no-check-certificate https://bintray.com/artifact/download/tigervnc/stable/ubuntu-14.04LTS/amd64/tigervncserver_1.6.0-3ubuntu1_amd64.deb
sudo dpkg -i tigervncserver_1.6.0-3ubuntu1_amd64.deb
sudo apt-get -f -y install

# Configuration for TigerVNC
## run vncserver for password
echo -e "vncpass\nvncpass\nn" | vncserver

## kill server and edit xstartup
vncserver -kill :1

cat > ~/.vnc/xstartup << EOF
#!/bin/sh

export XKL_XMODMAP_DISABLE=1
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &

gnome-session &
gnome-panel &
gnome-settings-daemon &
metacity &
nautilus &
gnome-terminal &
EOF

sudo touch /etc/init.d/vncserver

sudo cat > /etc/init.d/vncserver << EOF
#!/bin/bash

unset VNCSERVERARGS
VNCSERVERS=""
[ -f /etc/vncserver/vncservers.conf ] && . /etc/vncserver/vncservers.conf
prog=$"VNC server"
start() {
 . /lib/lsb/init-functions
 REQ_USER=$2
 echo -n $"Starting $prog: "
 ulimit -S -c 0 >/dev/null 2>&1
 RETVAL=0
 for display in ${VNCSERVERS}
 do
 export USER="${display##*:}"
 if test -z "${REQ_USER}" -o "${REQ_USER}" == ${USER} ; then
 echo -n "${display} "
 unset BASH_ENV ENV
 DISP="${display%%:*}"
 export VNCUSERARGS="${VNCSERVERARGS[${DISP}]}"
 su ${USER} -c "cd ~${USER} && [ -f .vnc/passwd ] && vncserver :${DISP} ${VNCUSERARGS}"
 fi
 done
}
stop() {
 . /lib/lsb/init-functions
 REQ_USER=$2
 echo -n $"Shutting down VNCServer: "
 for display in ${VNCSERVERS}
 do
 export USER="${display##*:}"
 if test -z "${REQ_USER}" -o "${REQ_USER}" == ${USER} ; then
 echo -n "${display} "
 unset BASH_ENV ENV
 export USER="${display##*:}"
 su ${USER} -c "vncserver -kill :${display%%:*}" >/dev/null 2>&1
 fi
 done
 echo -e "\n"
 echo "VNCServer Stopped"
}
case "$1" in
start)
start $@
;;
stop)
stop $@
;;
restart|reload)
stop $@
sleep 3
start $@
;;
condrestart)
if [ -f /var/lock/subsys/vncserver ]; then
stop $@
sleep 3
start $@
fi
;;
status)
status Xvnc
;;
*)
echo $"Usage: $0 {start|stop|restart|condrestart|status}"
exit 1
esac
EOF

# Make executable
sudo chmod +x /etc/init.d/vncserver

# Create folder
sudo mkdir -p /etc/vncserver

# Setup conf for VNC
sudo cat > /etc/vncserver/vncservers.conf << EOF
VNCSERVERS="1:default"
VNCSERVERARGS[1]="-geometry 1024x768"
EOF

# defaults
sudo update-rc.d vncserver defaults 99

# Run VNCSERVER
vncserver
 



