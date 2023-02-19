#!/bin/bash

if [[ $1 == "up" ]]; then
    echo $((`cat /sys/class/backlight/intel_backlight/actual_brightness` + 50)) | tee /sys/class/backlight/intel_backlight/brightness
elif [[ $1 == "down" ]]; then
    echo $((`cat /sys/class/backlight/intel_backlight/actual_brightness` - 50)) | tee /sys/class/backlight/intel_backlight/brightness
fi
