#!/bin/bash
#
# Handler script for udev - must run as user, not root
# NOTE: Replace <YOUR_USERNAME> with your actual username
#

USERNAME="<YOUR_USERNAME>"

# Wait a moment for the display to stabilize
sleep 2

# Get the display and i3 socket from the environment
export DISPLAY=:0
export XAUTHORITY="/home/${USERNAME}/.Xauthority"

# Find the i3 socket
export I3SOCK=$(ls /run/user/$(id -u ${USERNAME})/i3/ipc-socket.* 2>/dev/null | head -n1)

# Run the display switch script as the user
su ${USERNAME} -c "/home/${USERNAME}/.local/bin/i3-display-switch.sh"
