#!/bin/bash

get_longest_string_length() {
    local strings_arr=("${!1}") # Use indirect expansion to get the array
    local longest_string_length=0

    for string in "${strings_arr[@]}"; do # Iterate over array elements
        if [ ${#string} -gt "$longest_string_length" ]; then
            local string_length=${#string}
            longest_string_length=$string_length
        fi
    done

    echo "$longest_string_length"
}
