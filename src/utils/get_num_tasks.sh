#!/bin/bash

# return the number of running task or processes
get_num_tasks() {
    local num_tasks=$(($(ps -e | wc -l) - 1)) ||
        num_tasks="Unknown"
    echo "$num_tasks"
}
