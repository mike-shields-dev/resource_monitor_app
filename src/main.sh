#!/bin/bash

# shellcheck disable=SC1091
source './utils/get_hostname.sh'
source './utils/get_OS.sh'
source './utils/get_num_tasks.sh'
source './utils/get_uptime.sh'
source './utils/get_free_RAM.sh'
source './utils/get_disk_size.sh'
source './utils/get_disk_space.sh'
source './utils/get_host_IP.sh'
source './utils/get_IP_mode.sh'
source './utils/get_longest_string_length.sh'
source './utils/print_header.sh'
source './utils/print_row.sh'
source './utils/print_row_separator.sh'
source './utils/print_bottom_border.sh'

print_table() {
    # An array containing the names of table keys (odd indexes)
    # and refs to the table value getter functions (even indexes)
    # (see the for-loop below)
    table_padding=1
    table_header_text="System Information"
    table_data=(
        "Host Name" get_hostname
        "Operating System" get_OS
        "Running Tasks" get_num_tasks
        "System Up-Time" get_uptime
        "Available RAM" get_free_RAM
        "Total Disk Space" get_disk_size
        "Free Disk Space" get_disk_space
        "Host IP Address" get_host_IP
        "IP Addressing Mode" get_IP_mode
    )

    # temporary arrays that hold the table's
    # keys and values to be passed to the
    # get_longest_string_length function
    local table_keys=()
    local table_values=()

    # populate the table_keys and table_values arrays
    for ((i = 0; i < ${#table_data[@]}; i += 2)); do
        # extract the table key
        table_keys+=("${table_data[i]}")
        # execute the table value getter function
        table_values+=("$("${table_data[i + 1]}")")
    done

    # get the longest table key and table value lengths
    local longest_key_length
    longest_key_length=$(($(get_longest_string_length table_keys[@])))
    local longest_value_length
    longest_value_length=$(($(get_longest_string_length table_values[@])))

    # Print the table header
    print_header $longest_key_length $longest_value_length "$table_header_text" $table_padding

    # loop the table_data array and print each row
    for ((i = 0; i < ${#table_data[@]}; i += 2)); do
        # get the table key
        key="${table_data[i]}"
        # execute table value getter
        value=$("${table_data[i + 1]}")

        # print key and value in the row
        print_row "$key" "$value" $longest_key_length $longest_value_length $table_padding

        # if the row is not the last row
        if [ $i -lt $((${#table_data[@]} - 2)) ]; then
            # append the row with the row separator
            print_row_separator $longest_key_length $longest_value_length $table_padding
        else
            # append the row with the bottom border
            print_bottom_border $longest_key_length $longest_value_length $table_padding
        fi
    done
}

# table values cached at the time of the last table update
# they are used to determine if the table should update
# when the update interval has elapsed
# (initialised with the current system values)
prev_host_name=$(get_hostname)
prev_OS=$(get_OS)
prev_num_tasks=$(get_num_tasks)
prev_free_RAM=$(get_free_RAM)
prev_disk_size=$(get_disk_size)
prev_disk_space=$(get_disk_space)
prev_IP_address=$(get_host_IP)
prev_IP_mode=$(get_IP_mode)

# the last time that the table was updated
# initialised with the time the script was started
update_timestamp=$(date +%s)
# interval in seconds after which the table should check for updates
update_interval_secs=10

# the main function
main() {
    # print the table the first time
    print_table

    # an infinite loop that updates and prints the table,
    # while the script is running
    while true; do
        # get the current time at each iteration
        local current_time
        current_time=$(date +%s)

        # calculate the amount of time that has elapsed since
        # the last time the table updated
        local elapsed_time=$((current_time - update_timestamp))

        # if the amount of time elapsed since the last table update
        # exceeds the specified update interval
        if ((elapsed_time > update_interval_secs)); then
            # get the current system information
            local curr_hostname
            curr_hostname=$(get_hostname)
            local curr_OS
            curr_OS=$(get_OS)
            local curr_num_tasks
            curr_num_tasks=$(get_num_tasks)
            local curr_uptime=$(get_uptime)
            local curr_free_RAM
            curr_free_RAM=$(get_free_RAM)
            local curr_disk_size
            curr_disk_size=$(get_disk_size)
            local curr_disk_space
            curr_disk_space=$(get_disk_space)
            local curr_IP_address
            curr_IP_address=$(get_host_IP)
            local curr_IP_mode
            curr_IP_mode=$(get_IP_mode)

            # compare the current system information against
            # the previous cache
            # run an update if there are any differences
            if [[ 
                "$curr_hostname" != "$prev_host_name" ||
                "$curr_OS" != "$prev_OS" ||
                "$curr_num_tasks" != "$prev_num_tasks" ||
                "$curr_free_RAM" != "$prev_free_RAM" ||
                "$curr_disk_size" != "$prev_disk_size" ||
                "$curr_disk_space" != "$prev_disk_space" ||
                "$curr_IP_address" != "$prev_IP_address" ||
                "$curr_IP_mode" != "$prev_IP_mode" ]]; then

                # clear the previously displayed table
                clear

                # print the updated table
                print_table

                # update the cached system values
                prev_host_name=$curr_hostname
                prev_OS=$curr_OS
                prev_num_tasks=$curr_num_tasks
                prev_free_RAM=$curr_free_RAM
                prev_disk_size=$curr_disk_size
                prev_disk_space=$curr_disk_space
                prev_IP_address=$curr_IP_address
                prev_IP_mode=$curr_IP_mode

                # update the timestamp with the current time
                update_timestamp=$current_time
            fi
        fi
    done
}

# start the app
main
