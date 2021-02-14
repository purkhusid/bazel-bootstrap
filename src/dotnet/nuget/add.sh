#! /usr/bin/env bash
set -eou pipefail

PACKAGE=$1
VERSION=$2

OUTPUT_DIR="$(pwd)/dotnet/nuget"
FILE_NAME="nuget.bzl"

(
    cd $(git rev-parse --show-toplevel)
    bazel run @io_bazel_rules_dotnet//tools/nuget2bazel:nuget2bazel.exe -- add -p $(pwd)/src/dotnet/nuget -b nuget.bzl --indent "${PACKAGE}" "${VERSION}"
)