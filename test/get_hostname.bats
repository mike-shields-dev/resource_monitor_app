load 'test_helper/bats-assert/load'
load "../src/utils/get_hostname.sh"

@test "get_host_name returns 'Unknown' if acquisition of hostname fails" {
    # mock the hostname command and return an error status
    hostname() { return -1; }
    expect="Unknown"
    result=$(get_hostname)

    assert_equal $result "Unknown"
}

@test "get_host_name returns non-empty string if acquisition of hostname succeeds" {
    result=$(get_hostname)

    assert_not_equal $result ""
}
