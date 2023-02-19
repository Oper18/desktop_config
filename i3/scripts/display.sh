#!/bin/bash

#STATUS_OLD=$(cat /sys/class/drm/card0-HDMI-A-1/status)
#STATUS_NEW=$(cat /sys/class/drm/card0-HDMI-A-1/status)

STATUS_OLD=$(xrandr | grep HDMI | awk '{print $2}' | head -n 1)
STATUS_NEW=$(xrandr | grep HDMI | awk '{print $2}' | head -n 1)

while true
do
    STATUS_NEW=$(xrandr | grep HDMI | awk '{print $2}' | head -n 1)
    if [[ "$STATUS_NEW" == "disconnected" && "$STATUS_NEW" != "$STATUS_OLD" ]]; then
#        echo "disconnected monitor"
#        xrandr --output eDP-1 --mode 1920x1080
        xrandr --auto
	STATUS_OLD=$(xrandr | grep HDMI | awk '{print $2}' | head -n 1)
	sleep 1s
    elif [[ "$STATUS_NEW" == "connected" && "$STATUS_NEW" != "$STATUS_OLD" ]]; then
#        echo "connected monitor"
        xrandr --auto --output eDP-1 --left-of HDMI-1
	STATUS_OLD=$(xrandr | grep HDMI | awk '{print $2}' | head -n 1)
	sleep 1s
    else
#        echo "no changes"
	sleep 1s
    fi
done
