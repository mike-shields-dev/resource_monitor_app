#!/bin/bash

# Get the directory of the current script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source your main script using the absolute path
source "$script_dir/../src/main.sh"

# Set the expected hostname
expect="the host name"

# Mock the hostname command
hostname() { echo "$expect"; }

# Call the function and capture the result
result=$(get_hostname)

echo -n "get_hostname should return the device's hostname -> "

# Check if the result matches the expected value
if [ "$result" = "$expect" ]; then
    echo "true"
else
    echo "false"
fi
