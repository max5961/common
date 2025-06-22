#!/usr/bin/env bash

# Run on startup to prevent notify-send messages from disappearing into the void
# Logs to $LOG_FILE

LOG_FILE="$HOME/.custom-dbus-monitor.log"
TMP_PIDS="/tmp/log-dbus-pid"
OLD_PIDS=$(cat "$TMP_PIDS")

for pid in $OLD_PIDS; do
    kill $pid >/dev/null 2>&1
done
echo "$$" >> "$TMP_PIDS"

while read -r line; do
    curr_date="[$(date "+%a %D %H:%M:%S")]"
    result=$(echo $line | grep -i string)

    if [[ ! -z "$result" ]]; then
        result=$(echo "$result" | sed 's/^string //' | sed 's/"//g')
        case "$result" in
            sender-pid|urgency|notify-send)
                ;;
            *)
                if [[ ! -z "$result" && "$result" != 'string ""' ]]; then
                    echo "${curr_date} ${result}" >> "$LOG_FILE"
                fi
                ;;
        esac
    fi
done < <(dbus-monitor "interface='org.freedesktop.Notifications'")



