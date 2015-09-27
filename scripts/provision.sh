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
sudo apt-get install -y Xvfb xdotool

# Install wine
sudo dpkg --add-architecture i386
sudo add-apt-repository -y ppa:ubuntu-wine
sudo apt-get update
sudo apt-get install -y wine

# Upgrade manually some packages from the source.
sudo apt-get install -y libx11-dev libxtst-dev libxinerama-dev libxkbcommon-dev

# Install xdotool.
git clone https://github.com/jordansissel/xdotool && make -C xdotool

# Run X virtual framebuffer on screen 0.
Xvfb :0 -screen 0 1024x768x16 & # Run X virtual framebuffer on screen 0.

# Give vagrant write permission for /opt.
sudo chown -R vagrant:vagrant /opt

echo "$0 done."
