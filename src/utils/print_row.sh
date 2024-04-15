#!/bin/bash

print_row() {
    local key=$1
    local value=$2
    local longest_key_length=$3
    local longest_value_length=$4
    local padding=$5

    # Calculate the padding required for key and value columns
    local key_padding=$((longest_key_length - ${#key} + padding))
    local value_padding=$((longest_value_length - ${#value} + padding))

    # Print the row with formatted key and value
    printf "║ %s%*s│ %s%*s║\n" "$key" "$key_padding" "" "$value" "$value_padding" ""
}
