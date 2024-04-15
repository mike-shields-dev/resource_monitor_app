#!/bin/bash

# get the amount of free RAM
# in the most appropriate human readabl SI units
get_free_RAM() {
    local free_RAM
    free_RAM=$(
        free -h --si |
            awk 'NR==2 {print $4}'
    ) ||
        free_RAM="Unknown"
    echo "$free_RAM"B
}
