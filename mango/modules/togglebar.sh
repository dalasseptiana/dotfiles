#!/bin/sh


if pgrep -x "waybar" > /dev/null; then
    pkill -SIGUSR1 waybar
else
    waybar &
fi
