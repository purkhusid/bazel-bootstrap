#! /usr/bin/env bash
set -e

# This script should be run from the root of the monorepo
go get "${1}"
./bazel run //:gazelle -- update-repos -from_file=go.mod -to_macro=src/go/godeps_macro.bzl%go_repositories
