#!/usr/bin/env bats

@test "jenkins service is running" {
  result="$( service jenkins status | grep -oP '(?<=Active: )\w+' )"
  [ "$result" == "active" ]
}
