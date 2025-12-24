#!/bin/bash
# Get the current display and D-Bus session address from the current session
export DISPLAY=$(grep -z DISPLAY= /proc/$(pgrep -u $USER awesome)/environ | cut -d= -f2-)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS= /proc/$(pgrep -u $USER awesome)/environ | cut -d= -f2-)

# Run the notify-send command
notify-send "Not friendly remind" "Get up and squat, creature!!!"
