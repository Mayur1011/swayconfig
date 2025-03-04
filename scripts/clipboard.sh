#!/bin/sh
 
dir="$HOME/.config/rofi/launchers/type-1"
theme='style-5'
 
if pgrep -x rofi; then
  pkill -x rofi
else
  cliphist list | rofi -dmenu -theme ${dir}/${theme}.rasi | cliphist decode | wl-copy
  # rofi -normal-window -show drun
fi
