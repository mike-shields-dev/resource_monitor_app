#!/bin/bash

# get the primary IP address
get_host_IP() {
    local host_name
    host_name=$(
        hostname -I |
            awk '{print $1}'
    ) ||
        host_name="Unknown"
    echo "$host_name"
}
