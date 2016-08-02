#!/usr/bin/env bats

@test "jenkins port is listening" {
  result="$( netstat -plan | grep -q ':8080' )"
  status=$?
  [ "$status" -eq 0 ]
}
