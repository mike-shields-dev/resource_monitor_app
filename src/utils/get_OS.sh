#!/bin/bash

# return the device operating system
# or "Unknown" if the command fails
get_OS() {
    local op_sys
    op_sys=$(
        lsb_release -d |
            awk '{ for(i=2; i<=NF; i++) printf "%s ", $i }'
    ) ||
        op_sys="Unknown"
    echo "$op_sys"
}
