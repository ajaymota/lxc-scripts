# LXC-Scripts

These are linux commands for creating a PaaS system which allows users to
run linux based desktops in their browsers

# Recommended Environment

- DigitalOcean Cloud VPS (theoretically any should do)
- Ubuntu 14.04 LTS
- Root SSH Access
- An internet connection having less than 60ms ping

# Technologies Used

- Guacamole
- TigerVNC
- PulseAudio
- LXC

# System Features

If all the commands run properly, you will have a system where :-

1. An LXC container is created which will have the following installed,
   - Ubuntu 14.04
   - Mate Desktop
   - TigerVNC
   - PulseAudio
   
2. A server will be confirgured which will have the following installed,
   - Guacamole with VNC & PulseAudio support
   - Apache Tomcat
   - LXC services
