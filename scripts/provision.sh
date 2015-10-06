#!/bin/bash -x

#
# Provisioning script
#

# Initialize script.
if [ ! -d "/vagrant/scripts" ]; then
  echo "This script needs to be run within vagrant VM."
  exit 1
fi

whoami && pwd
shopt -s globstar # Enable globbing.

# Perform an unattended installation of a Debian packages.
sudo ex +"%s@DPkg@//DPkg" -cwq /etc/apt/apt.conf.d/70debconf
sudo dpkg-reconfigure debconf -f noninteractive -p critical

# Install and run X virtual framebuffer.
sudo apt-get install -y Xvfb xdotool winbind git
Xvfb :9 -screen 9 1024x768x16 &

# Install wine
sudo dpkg --add-architecture i386
sudo add-apt-repository -y ppa:ubuntu-wine/ppa
sudo apt-get update
sudo apt-get install -y wine1.7

# Workaround for bad GNU TLS linking in Wine
ln -s /usr/lib/i386-linux-gnu/libgnutls-deb0.so.28 /usr/lib/i386-linux-gnu/libgnutls.so.26

# Give vagrant write permission for /opt.
sudo chown -R vagrant:vagrant /opt

echo "$0 done."
