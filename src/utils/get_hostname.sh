#!/bin/bash

# return the hostname
get_hostname() {
    local host_name
    host_name=$(hostname) || host_name="Unknown"
    echo "$host_name"
}
