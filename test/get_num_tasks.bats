#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

load "../src/utils/get_num_tasks.sh"

@test "get_num_tasks returns a number" {
    run get_num_tasks
    assert_success
}
