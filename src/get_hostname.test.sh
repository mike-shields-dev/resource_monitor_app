#!/bin/bash

# Source your main script
source main.sh

# Set the expected hostname
expect="the host name"

# Mock the hostname command
hostname() { echo "$expect"; }

# Call the function and capture the result
result=$(get_hostname)

# Check if the result matches the expected value
if [ "$result" = "$expect" ]; then
    echo "true"
else
    echo "false"
fi