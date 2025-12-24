#!/bin/bash

declare -A screensmap

while IFS= read -r line; do
  screensmap[$line]=$(xrandr | grep "^${line}" | awk '{print $2}')
done < <(xrandr | grep "^HDMI" | awk '{print $1}')
while IFS= read -r line; do
  screensmap[$line]=$(xrandr | grep "^${line}" | awk '{print $2}')
done < <(xrandr | grep "^DP" | awk '{print $1}')

check_screen_connection () {
  for screen in ${!screensmap[@]}
  do
    if [[ "${screensmap[$screen]}" == "connected" && "${screensmap[$screen]}" != "$(xrandr | grep "^${screen}" | awk '{print $2}')" ]]; then
      xrandr --output $screen --off
      xrandr --output eDP-1 --scale 0.7
    elif [[ "${screensmap[$screen]}" == "disconnected" && "${screensmap[$screen]}" != "$(xrandr | grep "^${screen}" | awk '{print $2}')" ]]; then
      # xrandr --auto --output eDP-1 --scale 0.7x0.7 --left-of $screen
      resolution=$(xrandr | awk -v output="$screen" '$1 == output {getline; if ($1 ~ /^[0-9]+x[0-9]+$/) print $1; exit}')
      xrandr --output $screen --off
      xrandr --output eDP-1 --scale 1
      xrandr --output $screen --mode $resolution --right-of eDP-1
      xrandr --output eDP-1 --scale 0.7 --output $screen --mode $resolution  --right-of eDP-1
    fi
    screensmap[$screen]=$(xrandr | grep "^${screen}" | awk '{print $2}')
  done
}

while true
do
  check_screen_connection
  sleep 1s
done
