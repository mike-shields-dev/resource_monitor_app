#!/bin/bash

# get amount of free disk space in GB
get_disk_space() {
    local disk_space
    disk_space=$(
        df -BG / --output=avail |
            tail -n 1 |
            tr -d '[:space:]'
    ) ||
        disk_space="Unknown"
    echo "$disk_space"B
}
