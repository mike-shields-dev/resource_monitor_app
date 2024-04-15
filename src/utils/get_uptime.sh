#!/bin/bash

get_uptime() {
    # Get the system uptime in seconds
    uptime_seconds=$(cut -d' ' -f1 /proc/uptime | cut -d'.' -f1)

    # Calculate the hours and minutes
    hours=$((uptime_seconds / 3600))
    minutes=$((uptime_seconds % 3600 / 60))

    # Format the output as HH:MM
    formatted_uptime=$(printf "%02dh:%02dm" $hours $minutes)

    echo "$formatted_uptime"
}