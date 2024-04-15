#!/bin/bash

# return the device's hostname
# or "Unknown" if the command fails
get_hostname() {
    local host_name
    host_name=$(hostname) || host_name="Unknown"
    echo "$host_name"
}
