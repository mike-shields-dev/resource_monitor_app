#!/bin/bash

# return the Operating System name
get_OS() {
    local op_sys
    op_sys=$(lsb_release -d | cut -d ':' -f2-) || "Unknown"
    echo "$op_sys"
}