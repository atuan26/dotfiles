#!/bin/sh

# Check if the lock file exists
if [ -f /tmp/screensaver_inhibited ]; then
    # Re-enable screensaver and DPMS (values from i3 config)
    xset s 300 300
    xset dpms 600 600 600
    rm /tmp/screensaver_inhibited
    notify-send "Screensaver" "Auto-lock ENABLED (5m timeout)" -u low
else
    # Disable screensaver and DPMS
    xset s off
    xset -dpms
    touch /tmp/screensaver_inhibited
    notify-send "Screensaver" "Auto-lock DISABLED (Presentation/Meeting Mode)" -u normal
fi
