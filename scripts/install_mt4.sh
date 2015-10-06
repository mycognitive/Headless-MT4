#!/bin/bash -xe

# Delay in seconds for synchronizing routines
DELAY=4

# Configure Wine
export WINEPREFIX="/opt/.wine"
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:9.9

# Download and install MT4 platform
mkdir -p $WINEPREFIX
wget -c -P $WINEPREFIX https://download.mql5.com/cdn/web/metaquotes.software.corp/mt4/mt4setup.exe

# Install platform
wine $WINEPREFIX"/mt4setup.exe" &

# Wait until Wine initializes
while : ; do
	echo "Waiting for Wine to initialize..."
	sleep $DELAY
	set +e	# Workaround for xdotool issue #60
	WINDOW_ID=`xdotool search --name "MetaTrader 4 Setup*"`
	set -e	# Workaround for xdotool issue #60
	[[ -z $WINDOW_ID ]] || break
done

# Set focus on installer window and act to install platform
xdotool windowfocus $WINDOW_ID
xdotool key space Tab Tab Tab Return Tab Tab Tab space Alt+n

# Wait until installation is ready
while : ; do
	echo "Installing platform..."
	sleep $DELAY
        PS=`ps | grep "mt4setup.exe"`
        [[ ! -z $PS ]] || break
done

# Kill leftover Wine sessions & quit loop
wineserver -k

# Add files to the git repository
GITDIR="/opt/.git"

# Initialize git if its directory doesn't exist
if [[ ! -d $GITDIR ]]; then
	git --git-dir=$GITDIR init
	git config --global user.name mycognitive
	git config --global user.email mycognitive@users.noreply.github.com
fi
git --git-dir=$GITDIR add -A
git --git-dir=$GITDIR commit -m "$0: Installed MT4." -a

echo "$0 done."
