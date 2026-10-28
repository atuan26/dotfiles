#!/bin/bash

# Terminate already running bar instances
killall -q i3bar
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Primary monitor gets the main bar (with systray), others get the secondary bar
primary=$(xrandr --query | grep " connected primary" | cut -d" " -f1)
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    [ -z "$primary" ] && primary=$m
    if [ "$m" = "$primary" ]; then
        MONITOR=$m polybar --reload main &
    else
        MONITOR=$m polybar --reload secondary &
    fi
done

echo "Polybar launched..."
