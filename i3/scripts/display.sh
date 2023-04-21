#!/bin/bash

declare -A screensmap

while IFS= read -r line; do
  screensmap[$line]=$(xrandr | grep "^${line}" | awk '{print $2}')
done < <(xrandr | grep "^HDMI" | awk '{print $1}')
while IFS= read -r line; do
  screensmap[$line]=$(xrandr | grep "^${line}" | awk '{print $2}')
done < <(xrandr | grep "^DP" | awk '{print $1}')

echo ${screensmap[@]} ${!screensmap[@]}

check_screen_connection () {
  for screen in ${!screensmap[@]}
  do
    if [[ "${screensmap[$screen]}" == "connected" && "${screensmap[$screen]}" != "$(xrandr | grep "^${screen}" | awk '{print $2}')" ]]; then
      xrandr --auto
    elif [[ "${screensmap[$screen]}" == "disconnected" && "${screensmap[$screen]}" != "$(xrandr | grep "^${screen}" | awk '{print $2}')" ]]; then
      xrandr --auto --output eDP-1 --left-of $screen
    fi
    screensmap[$screen]=$(xrandr | grep "^${screen}" | awk '{print $2}')
  done
}

while true
do
  check_screen_connection
  sleep 1s
done
