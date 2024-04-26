bin/bash

# GETTER FUNCTIONS:
# These functions interrogate the system
# for the table's values

function get_hostname() {
    # return the device's hostname
    hostname
}

function get_OS() {
    # return the device's operating system
    lsb_release -d |
        awk '{ for(i=2; i<=NF; i++) printf "%s ", $i }'
}

function get_num_tasks() {
    # return the number of running task or processes
    echo $(($(ps -e | wc -l) - 1))
}

function get_uptime() {
    # Get the system uptime in seconds
    uptime_seconds=$(awk -F'.' '{print $1}' /proc/uptime)

    # Calculate the hours and minutes
    hours=$((uptime_seconds / 3600))
    minutes=$((uptime_seconds % 3600 / 60))

    # Format the output as HH:MM
    formatted_uptime=$(printf "%02dh:%02dm" $hours $minutes)

    echo "$formatted_uptime"
}

function get_total_RAM() {
    # get the total amount of RAM
    # in the most appropriate human-readable SI units
    # "B" stands for byte
    memory=$(free -h --si | grep "Mem" | awk '{print $3}')B
    echo "$memory"
}

function get_free_RAM() {
    # get the amount of free RAM in
    # the most appropriate human-readable SI units
    # "B" stands for byte
    memory=$(free -h --si | grep "Mem" | awk '{print $2}')B
    echo "$memory"
}

function get_disk_size() {
    # get the total disk size in GB
    echo "$(
        df -h --si / --output=size |
            tail -n 1 |
            tr -d '[:space:]'
    )B"
}

function get_disk_space() {
    # get amount of free disk space in GB
    echo "$(
        df -h --si / --output=avail |
            tail -n 1 |
            tr -d '[:space:]'
    )B"
}

function get_IP_addr() {
    # get the primary network interface IP address
    hostname -I | awk '{print $1}'
}

function get_IP_address_mode() {
    # get the IP addressing mode of the primary IP Address
    ip addr show scope global |
        grep "inet " |
        awk '{print $7}' |
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

    for string in "${strings_arr[@]}"; do # Iterate over array elements
        # if the current string's length is longer
        # update max_length
        if [[ ${#string} -gt ${#longest} ]]; then
            longest="$string"
        fi
    done

    echo "${#longest}"
}

# PRINTING FUNCTIONS
# Prints the header including box-drawing character
# based on the computed table dimensions
function print_header() {

    local header_length=${#header_text}
    local padding=$(((header_inner_width - header_length) / 2))

    echo -n "╔"
    printf "═%.0s" $(seq 1 "$header_inner_width")
    echo "╗"
    printf "║"
    printf "%*s" $((padding + header_length)) "$header_text"
    printf "%*s" $((header_inner_width - padding - header_length)) ""
    echo "║"
    printf "╠"
    printf "═%.0s" $(seq 1 "$header_inner_width")
    printf "╣\n"
}

# Prints all rows that are not the last row
function print_intermediate_row() {
    index=$1
    key="${table_keys[index]}"
    value="${table_values[index]}"
    # Print the row with formatted key and value
    echo -n "║ "
    echo -n "$key"
    # Pad the right side of the key column
    printf "%*s" $((key_column_inner_width - ${#key} - 1)) ""
    echo -n "│"
    echo -n " "
    echo -n "$value"
    printf "%0.s " $(seq 1 $((value_column_inner_width - ${#value} - 1)))
    echo "║"

    # Print bottom border
    echo -n "╟"
    printf "─%.0s" $(seq 1 "${key_column_inner_width}")
    echo -n "┼"
    printf "─%.0s" $(seq 1 "${value_column_inner_width}")
    echo "╢"
}

# Prints the last row
function print_last_row() {
    index=$1
    key="${table_keys[index]}"
    value="${table_values[index]}"
    # Print the row with formatted key and value
    echo -n "║"
    echo -n " "
    echo -n "${table_keys[index]}"
    printf "%*s" $((key_column_inner_width - ${#key} - 1)) ""
    echo -n "│"
    echo -n " "
    echo -n "${table_values[index]}"
    printf "%0.s " $(seq 1 $((value_column_inner_width - ${#value} - 1)))
    echo "║"

    # Print bottom border
    echo -n "╚"
    printf "═%.0s" $(seq 1 "${key_column_inner_width}")
    echo -n "╧"
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

    # Determine the interal width of the table's header
    # "+ 2" represents the padding either side of the key
    header_inner_width=$((${#header_text} + 2))

    # Conditional statements that eliminate any width differences
    # between the header and rows so that
    # the table's alignment is maintained if it's contents change
    if ((header_inner_width < row_inner_width)); then
        header_inner_width=$row_inner_width
    fi

    if ((header_inner_width > row_inner_width)); then
        value_column_inner_width=$((header_inner_width - key_column_inner_width - 1))
    fi
}

# Prints the table
# this function is also responsible for calculating the
# table's dimensions based on the lengths of:
# - table header banner
# - longest table key
# - longest table value
function print_table() {
    update_table_values

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

export key_column_inner_width
export value_column_inner_width
export header_inner_width

# !! IMPORTANT:
# Ensure the proper sequential relationship between
# the table's keys and getter functions is
# maintained.

# A list of references to the getter functions
export table_funcs=(
    get_hostname
    get_OS
    get_num_tasks
    get_uptime
    get_total_RAM
    get_free_RAM
    get_disk_size
    get_disk_space
    get_IP_addr
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
    "Total Disk Space"
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
