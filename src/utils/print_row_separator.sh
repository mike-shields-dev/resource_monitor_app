#!/bin/bash

print_row_separator() {
    local padding=$3
    local key_col_width=$(($1 + (padding * 2)))
    local value_col_width=$(($2 + (padding * 2)))

    printf "╟"
    printf "─%.0s" $(seq 1 "${key_col_width}")
    printf "┼"
    printf "─%.0s" $(seq 1 "${value_col_width}")
    printf "╢\n"
}
