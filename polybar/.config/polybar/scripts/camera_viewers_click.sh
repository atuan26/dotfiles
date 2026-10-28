#!/bin/bash

# OUTPUT=$(echo "netstat -ant" |
#     sshpass -p 'Abcd1234@' ssh -T \
#         -o StrictHostKeyChecking=no \
#         -o LogLevel=ERROR \
#         admin@10.6)

# IPS=$(echo "$OUTPUT" |
#     awk '/ESTABLISHED/ {
#         peer=$5
#         sub(/:[0-9]+$/, "", peer)
#         sub(/^::ffff:/, "", peer)

#         if (peer != "10.0.0.46")
#             print peer
#     }' |
#     sort -u)

# if [ -z "$IPS" ]; then
#     notify-send "󰕥" "You might be safe temporarily. Be aware!"
# else
#     notify-send "🕵Sus detected. Stay safe!" "$IPS"
# fi


#!/bin/bash

METRIC_FILE="/var/lib/node_exporter/textfile_collector/remote_device.prom"
TMP_FILE="${METRIC_FILE}.tmp"

WARNING_ICON="%{F#f1fa8c}%{F-}"
ERROR_ICON="%{F#ff5555}󰈈%{F-}"
OK_ICON="%{F#50fa7b}󰕥%{F-}"

OUTPUT=$(echo "netstat -ant" |
    sshpass -p 'Abcd1234@' ssh -T \
        -o StrictHostKeyChecking=no \
        -o LogLevel=ERROR \
        admin@10.6 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "$WARNING_ICON"
    exit 0
fi

IPS=$(echo "$OUTPUT" |
    awk '/ESTABLISHED/ {
        peer=$5
        sub(/:[0-9]+$/, "", peer)
        sub(/^::ffff:/, "", peer)

        if (peer != "10.0.0.46")
            print peer
    }' |
    sort -u)

if [ -z "$IPS" ]; then
    STATUS=0
    ICON="$OK_ICON"
else
    STATUS=1
    ICON="$ERROR_ICON"
fi

if ! cat > "$TMP_FILE" <<EOF
# HELP remote_device_unexpected_connection Whether an unexpected connection exists
# TYPE remote_device_unexpected_connection gauge
remote_device_unexpected_connection{device="10.6"} $STATUS
EOF
then
    echo "$WARNING_ICON"
    exit 0
fi

if ! mv -f "$TMP_FILE" "$METRIC_FILE"; then
    echo "$WARNING_ICON"
    exit 0
fi

# Polybar click action
if [ "$1" = "click" ]; then
    if [ -z "$IPS" ]; then
        notify-send "󰕥" "You might be safe temporarily. Be aware!"
    else
        notify-send "🕵 Sus detected. Stay safe!" "$IPS"
    fi
    exit 0
fi

echo "$ICON"