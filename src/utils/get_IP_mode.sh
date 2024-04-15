#!/bin/bash

# get the IP Addressing mode of the primary IP Address
get_IP_mode() {
    local ip_mode
    ip_mode=$(
        ip addr show scope global |
            grep "inet " |
            awk '{print $7}' |
            sed -e 's/.*/\u&/'
    ) ||
        ip_mode="Unknown"
    echo "$ip_mode"
}
