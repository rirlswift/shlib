#!/bin/sh

# github_last_release: returns the last release version or error
#
# Requires: http_download, is_command
#
# hack to extract version from output is based on
#
# https://github.com/golang/dep/blob/master/install.sh
#
#  1. tr -s '\n' ' ' --> make sure output is exactly one line
#  2. sed 's/.*"tag_name":"//'  --> remove everything before
#  3. sed 's/".*//' --> remove everything after
#
#  what remains is the version number
#
github_last_release() {
  owner_repo=$1
  version=$2
  test -z "$version" && version="latest"
  giturl="https://github.com/${owner_repo}/releases/${version}"
  json=$(http_download "-" "$giturl" "Accept:application/json")
  version=$(echo "$json" | tr -s '\n' ' ' | sed 's/.*"tag_name":"//' | sed 's/".*//')
  test -z "$version" && return 1
  echo "$version"
}
