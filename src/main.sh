#!/bin/bash

# GETTER FUNCTIONS:
# These functions interrogate the system
# for the table's values

function get_hostname() {
    # Get and return the device's hostname
    hostname
}

function get_OS_name() {
  # Get and return the Operating System description name
  lsb_release -d | cut -f2  
}

function get_num_tasks() {
    # Get and return the number of running tasks or processes
    echo $(($(ps -e | wc -l) - 1))
}

function get_uptime() {
    # Get the system uptime in seconds
    uptime_seconds=$(awk -F'.' '{print $1}' /proc/uptime)
    # Calculate the hours and minutes past the hour
    hours=$((uptime_seconds / 3600))
    minutes=$((uptime_seconds % 3600 / 60))
    # Format the output as 00h:00m
    formatted_uptime=$(printf "%02dh:%02dm" $hours $minutes)
    # Return the result
    echo "$formatted_uptime"
}

function get_total_RAM() {
    # Get the total amount of RAM
    # in the most appropriate human-readable SI units
    # Append the character "B" (stands for byte)
    memory=$(free -h --si | grep "Mem" | awk '{print $2}')B
    # Return the result
    echo "$memory"
}

function get_free_RAM() {
    # Get the amount of free RAM in the 
    # most appropriate human-readable SI units the 
    # Append the character "B" (stands for byte)    
    memory=$(free -h --si | grep "Mem" | awk '{print $4}')B
    # Return the result
    echo $memory
}

function get_disk_size() {
    # Get the total disk size in GB the 
    # Append "B" (stands for byte)
    echo "$(df -h --si --total --output=size | awk 'END {print $1}')B"
}

function get_disk_space() {
    # Get and return the amount of free disk space in GB the 
    # appended "B" stands for "byte"
    echo "$(df -h --si --output=avail --total | awk 'END {print $1}')B"
}

function get_IP_address() {
    # Get the primary network interface IP address
    hostname -I | awk '{print $1}'
}

function get_IP_address_mode() {
    # Get and return the IP addressing mode of the primary IP Address
    ip -4 addr show scope global | 
        awk 'NR == 2 {print $7}' | 
        sed -e 's/.*/\u&/'
}

# Runs each table value getter function and
# updates the table_values list
function update_table_values() {
    # updates the table values using the
    # getter functions defined above
    # loop the table_data array and print each row
    for ((i = 0; i < ${#table_funcs[@]}; i++)); do
        func="${table_funcs[i]}"
        table_values[i]="$($func)"
    done
}

# A function that returns the maximum string length
# in a list of strings
function max_string_length() {
    local strings_arr=("${!1}") # Expand the provided array of strings
    local longest
    # Iterate the strings array
    for string in "${strings_arr[@]}"; do 
        # if the current string's length is longer
        # update longest
        if [[ ${#string} -gt ${#longest} ]]; then
            longest="$string"
        fi
    done
    # Return the length of longest string
    echo "${#longest}"
}

# PRINTING FUNCTIONS
# Prints the header including box-drawing character
# based on the computed table dimensions
function print_header() {
    local header_length=${#header_text}
    local padding=$(((header_inner_width - header_length) / 2))
    # Print top border
    echo -n "╔"
    printf "═%.0s" $(seq 1 "$header_inner_width")
    echo "╗"
    # Print the row body
    echo -n "║"
    # Print the header_text center aligned
    printf "%*s" $((padding + header_length)) "$header_text"
    printf "%*s" $((header_inner_width - padding - header_length)) ""
    echo "║"
    # Print bottom border
    echo -n "╠"
    # Print the left section according to the key column width
    printf "═%.0s" $(seq 1 "${key_column_inner_width}")
    # Print the divider
    echo -n "╤"
    # Print the right section according to the value column width
    printf "═%.0s" $(seq 1 "${value_column_inner_width}")
    echo "╣"
}

# Prints all rows that are not the last row
function print_intermediate_row() {
    index=$1
    # Get the row key according to index
    key="${table_keys[index]}"
    # Get the row value according to index
    value="${table_values[index]}"
    # Print the row with formatted key and value
    echo -n "║ "
    # Print the key
    echo -n "$key"
    # Pad the right side of the key column
    printf "%*s" $((key_column_inner_width - ${#key} - 1)) ""
    # Print the divider
    echo -n "│ "
    # Print the value
    echo -n "$value"
    # Pad the right side of the value column
    printf "%0.s " $(seq 1 $((value_column_inner_width - ${#value} - 1)))
    echo "║"

    # Print bottom border
    echo -n "╟"
    # Print the left section according to the key column width
    printf "─%.0s" $(seq 1 "${key_column_inner_width}")
    # Print the divider
    echo -n "┼"
    # Print the right section according to the value column width
    printf "─%.0s" $(seq 1 "${value_column_inner_width}")
    echo "╢"
}

# Prints the last row
function print_last_row() {
    index=$1
    # Get the row key according to the index
    key="${table_keys[index]}"
    # Get the row value according to the index
    value="${table_values[index]}"
    # Print the row with formatted key and value
    echo -n "║ "
    # Print the key
    echo -n "$key"
    # Pad the right side of the key column
    printf "%*s" $((key_column_inner_width - ${#key} - 1)) ""
    # Print the divider
    echo -n "│ "
    # Print the value
    echo -n "$value"
    # Pad the right side of the value column
    printf "%0.s " $(seq 1 $((value_column_inner_width - ${#value} - 1)))
    echo "║"

    # Print bottom border
    echo -n "╚"
    # Print the left side according to the key column width
    printf "═%.0s" $(seq 1 "${key_column_inner_width}")
    echo -n "╧"
    # Print the right side according to the value column width
    printf "═%.0s" $(seq 1 "${value_column_inner_width}")
    echo "╝"
}

function calculate_table_dims() {
    update_table_values

    # Determine the longest table key
    longest_key_length=$(max_string_length table_keys[@])

    # Determine the longest table value
    longest_value_length=$(max_string_length table_values[@])

    # Determine the internal width of the table's key column
    # "+ 2" represents the padding either side of the key
    key_column_inner_width=$((longest_key_length + 2))

    # Determine the internal width of the table's value column
    # "+ 2" represents the padding either side of the key
    value_column_inner_width=$((longest_value_length + 2))

    # Determine the internal width of rows in the table
    # the "1" in the equation represents the box drawing character that
    # divides the table's columns
    row_inner_width=$((key_column_inner_width + 1 + value_column_inner_width))

    # Determine the internal width of the table's header
    # "+ 2" represents the padding either side of the key
    header_inner_width=$((${#header_text} + 2))

    # Conditional statements that eliminate any width differences
    # between the header and rows so that the 
    # table's alignment is maintained if its contents change
    if ((header_inner_width < row_inner_width)); then
        header_inner_width=$row_inner_width
    fi

    if ((header_inner_width > row_inner_width)); then
        value_column_inner_width=$((header_inner_width - key_column_inner_width - 1))
    fi
}

# Prints the table
function print_table() {
    # Update the table's values
    update_table_values

    # Update the table's dimensions
    calculate_table_dims

    # Print the table header
    print_header

    # Print the table rows
    for ((i = 0; i < ${#table_keys[@]}; i++)); do
        # not the last row
        if ((i < ${#table_keys[@]} - 1)); then
            print_intermediate_row "$i"
        # the last row
        else
            print_last_row "$i"
        fi
    done
}

# Table dimensions
export key_column_inner_width
export value_column_inner_width
export header_inner_width

# !! IMPORTANT:
# Ensure the proper sequential relationship between the 
# table's keys and getter functions are maintained.

# A list of references to the getter functions
export table_funcs=(
    get_hostname
    get_OS_name
    get_num_tasks
    get_uptime
    get_total_RAM
    get_free_RAM
    get_disk_size
    get_disk_space
    get_IP_address
    get_IP_address_mode
)

# The list of table keys
export table_keys=(
    "Host Name"
    "Operating System"
    "Running Tasks"
    "System Up-Time"
    "Total RAM"
    "Available RAM"
    "Total Disk Size"
    "Free Disk Space"
    "Host IP Address"
    "IP Addressing Mode"
)

# A list to store the latest table values
export table_values=()

# The text that will be displayed in the table header
export header_text="Adex System Resource Monitor"

# the main function
main() {
    # The interval at which the table updates
    export refresh_interval_secs=10
    # get the initial system information and update
    # the table's 0values
    update_table_values

    # print the table the first time
    # with the current table values
    print_table

    # an infinite loop that updates and prints the table,
    # while the script is running
    while true; do
        # update the table values
        update_table_values

        # clear the previously displayed table
        clear

        # print the table with the latest
        # table values
        print_table

        # wait for the designated duration
        sleep "$refresh_interval_secs"
    done
}

# Check if being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # This block will only execute if the file is executed, not sourced
    # start the app
    main
fi
