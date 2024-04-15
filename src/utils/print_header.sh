#!/bin/bash

print_header() {
    local longest_key=$1
    local longest_value=$2
    local header_text=$3
    local padding=$4
    local key_col_width=$((longest_key + (padding * 2)))
    local value_col_width=$((longest_value + (padding * 2)))
    local header_width=$((${#header_text} + padding * 2))
    local width_of_cols=$((key_col_width + value_col_width + 1))
    local table_width=

    if ((header_width > width_of_cols)); then
        table_width=$((header_width))
    else
        table_width="$width_of_cols"
    fi

    printf "╔"
    printf "═%.0s" $(seq 1 "${table_width}")
    printf "╗\n"
    printf "║ "
    printf '%s' "$header_text"
    printf "%0.s " $(seq 1 $((table_width - ${#header_text} - 1)))
    printf "║\n"
    printf "╠"
    printf "═%.0s" $(seq 1 "$((key_col_width))")
    printf "╤"
    printf "═%.0s" $(seq 1 "$((value_col_width))")
    printf "╣\n"
}
