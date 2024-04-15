#!/bin/bash

# get the total disk size in GB
get_disk_size() {
    local disk_size
    disk_size=$(
        df -BG / --output=size |
            tail -n 1 |
            tr -d '[:space:]'
    ) ||
        disk_size="Unknown"
    echo "$disk_size"B
}
