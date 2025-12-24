#!/bin/bash

if [[ $1 == "up" ]]; then
    echo $((`cat /sys/class/leds/asus::kbd_backlight/brightness` + 1)) | tee /sys/class/leds/asus::kbd_backlight/brightness
elif [[ $1 == "down" ]]; then
    echo $((`cat /sys/class/leds/asus::kbd_backlight/brightness` - 1)) | tee /sys/class/leds/asus::kbd_backlight/brightness
fi
