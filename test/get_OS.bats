#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

load "../src/utils/get_OS.sh"

@test "get_OS returns the operating system name" {
    # Mock lsb_release command to return the OS name
    lsb_release() { echo "Description: Ubuntu 20.04"; }

    run get_OS
    assert_success
    assert_output --partial "Ubuntu 20.04"
}
