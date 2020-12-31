#! /usr/bin/env bash

# If the user has set added BUILDBUDDY_API_KEY to their Gitpod settings
# we create a .bazelrc.user file which adds the needed authentication header
# See https://www.gitpod.io/docs/environment-variables/ for information on
# how to add environment variables to your Gitpod account
if [[ -n "${BUILDBUDDY_API_KEY}" ]]; then
    cat <<EOT >> .bazelrc.user
build --remote_header=x-buildbuddy-api-key=${BUILDBUDDY_API_KEY}
test --remote_header=x-buildbuddy-api-key=${BUILDBUDDY_API_KEY}
query --remote_header=x-buildbuddy-api-key=${BUILDBUDDY_API_KEY}
aquery --remote_header=x-buildbuddy-api-key=${BUILDBUDDY_API_KEY}
cquery --remote_header=x-buildbuddy-api-key=${BUILDBUDDY_API_KEY}
run --remote_header=x-buildbuddy-api-key=${BUILDBUDDY_API_KEY}
EOT
fi

if [[ -n "${GITPOD_WORKSPACE_URL}" ]]; then
    echo "startup --output_base=/workspace/bazel_output_base" >> .bazelrc.user
fi
