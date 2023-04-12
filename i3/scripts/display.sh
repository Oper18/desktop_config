#!/bin/bash

#STATUS_OLD=$(cat /sys/class/drm/card0-HDMI-A-1/status)
#STATUS_NEW=$(cat /sys/class/drm/card0-HDMI-A-1/status)

STATUS_OLD_HDMI=$(xrandr | grep HDMI | awk '{print $2}' | head -n 1)
STATUS_NEW_HDMI=$(xrandr | grep HDMI | awk '{print $2}' | head -n 1)

STATUS_OLD_DP=$(xrandr | grep "^DP" | awk '{print $2}' | head -n 1)
STATUS_NEW_DP=$(xrandr | grep "^DP" | awk '{print $2}' | head -n 1)

while true
do
    STATUS_NEW_HDMI=$(xrandr | grep HDMI | awk '{print $2}' | head -n 1)
    STATUS_NEW_DP=$(xrandr | grep "^DP" | awk '{print $2}' | head -n 1)
    if [[ "$STATUS_NEW_HDMI" == "disconnected" && "$STATUS_NEW_HDMI" != "$STATUS_OLD_HDMI" ]]; then
#        echo "disconnected monitor"
#        xrandr --output eDP-1 --mode 1920x1080
        xrandr --auto
	STATUS_OLD_HDMI=$(xrandr | grep HDMI | awk '{print $2}' | head -n 1)
	sleep 1s
    elif [[ "$STATUS_NEW_HDMI" == "connected" && "$STATUS_NEW_HDMI" != "$STATUS_OLD_HDMI" ]]; then
#        echo "connected monitor"
        xrandr --auto --output eDP-1 --left-of HDMI-1
	STATUS_OLD_HDMI=$(xrandr | grep HDMI | awk '{print $2}' | head -n 1)
	sleep 1s
    elif [[ "$STATUS_NEW_DP" == "disconnected" && "$STATUS_NEW_DP" != "$STATUS_OLD_DP" ]]; then
#        echo "disconnected monitor"
#        xrandr --output eDP-1 --mode 1920x1080
        xrandr --auto
	STATUS_OLD_DP=$(xrandr | grep "^DP" | awk '{print $2}' | head -n 1)
	sleep 1s
    elif [[ "$STATUS_NEW_DP" == "connected" && "$STATUS_NEW_DP" != "$STATUS_OLD_DP" ]]; then
#        echo "connected monitor"
        xrandr --auto --output eDP-1 --left-of DP-1
	STATUS_OLD_DP=$(xrandr | grep "^DP" | awk '{print $2}' | head -n 1)
	sleep 1s
    else
#        echo "no changes"
	sleep 1s
    fi
done
