#!/bin/bash -xe

OUT="/opt"

# Configure wine.
export WINEDLLOVERRIDES="mscoree,mshtml=" # Disable gecko in wine.
export DISPLAY=:0.0 # Select screen 0.
export WINEDEBUG=warn+all # For debugging, try: WINEDEBUG=trace+all

# Download and install MT4/MT5 platforms.
# @todo: 1. Download platform.
wget https://download.mql5.com/cdn/web/metaquotes.software.corp/mt4/mt4setup.exe
#wget https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe
#wget https://fx.instaforex.com/i/downloads/itc4setup.exe
#wget https://fx.instaforex.com/i/downloads/itc5setup.exe

# @todo: 2. Install platform (e.g. use xdotool to fake keyboard to navigate through the installator).
wine mt4setup.exe
#xdotool key Space n
#wineserver -k # Kill leftover wine sessions.

# Add files to the git repository.
git --git-dir=/opt/.git add -A
git --git-dir=/opt/.git commit -m"$0: Installed MT4." -a

echo "$0 done."
