#!/bin/bash

METRIC_FILE="/var/lib/node_exporter/textfile_collector/remote_device.prom"
IPS_FILE="/var/lib/remote-device/remote_device.ips"

WARNING_ICON="%{F#f1fa8c}%{F-}"
ERROR_ICON="%{F#ff5555}󰈈%{F-}"
OK_ICON="%{F#50fa7b}󰕥%{F-}"

# --------------------------------------------------
# Click
# --------------------------------------------------

if [ "$1" = "click" ]; then

    if [ ! -f "$METRIC_FILE" ]; then
        notify-send "" "Unable to check remote device"
        exit 0
    fi

    STATUS=$(
        awk '
            /^remote_device_unexpected_connection\{/ {
                print $NF
                exit
            }
        ' "$METRIC_FILE"
    )

    case "$STATUS" in

        0)
            notify-send \
                "󰕥" \
                "You might be safe temporarily. Be aware!!!"
            ;;

        1)
            if [ -s "$IPS_FILE" ]; then
                IPS=$(cat "$IPS_FILE")

                notify-send \
                    "🕵 Sus detected. Stay safe!" \
                    "$IPS"
            else
                notify-send \
                    "🕵 Sus detected. Stay safe!" \
                    "Unknown connection"
            fi
            ;;

        *)
            notify-send \
                "" \
                "Unable to determine remote device status"
            ;;

    esac

    exit 0
fi

# --------------------------------------------------
# Normal Polybar output
# --------------------------------------------------

if [ ! -f "$METRIC_FILE" ]; then
    echo "$WARNING_ICON"
    exit 0
fi

STATUS=$(
    awk '
        /^remote_device_unexpected_connection\{/ {
            print $NF
            exit
        }
    ' "$METRIC_FILE"
)

case "$STATUS" in

    0)
        echo "$OK_ICON"
        ;;

    1)
        echo "$ERROR_ICON"
        ;;

    *)
        echo "$WARNING_ICON"
        ;;

esac