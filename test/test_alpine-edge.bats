setup() {
  docker history "alpine:edge" >/dev/null 2>&1
}

@test "version is correct" {
  run docker run "alpine:edge" cat /etc/os-release
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=3.2.0_alpha1" ]
}

@test "package installs cleanly" {
  run docker run "alpine:edge" apk add --update openssl
  [ $status -eq 0 ]
}

@test "timezone" {
  run docker run "alpine:edge" date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "apk-install script should be missing" {
  run docker run "alpine:edge" which apk-install
  [ $status -eq 1 ]
}

@test "repository list is correct" {
  run docker run "alpine:edge" cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://dl-4.alpinelinux.org/alpine/edge/main" ]
}

@test "cache is empty" {
  run docker run "alpine:edge" sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}
