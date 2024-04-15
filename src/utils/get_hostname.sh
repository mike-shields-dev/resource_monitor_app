#!/bin/bash

# acquire and return the hostname or
# "Unknown" if unsuccessful

get_hostname() {
    local host_name
    host_name=$(hostname) || host_name="Unknown"
    echo "$host_name"
}
