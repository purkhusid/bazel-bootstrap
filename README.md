# Bazel Bootstrap

This repository contains a bootstrapping template for various programming 
languages built with [Bazel](https://bazel.build)

All the programming languages implement the same gRPC service if the tooling
supports gRPC. Otherwise the language will implement a simple http web service.

## Developing using Gitpod

The repository has been set up to work well with Gitpod. To start developing
using gitpod you can do the following:

1. Log into Gitpod: https://gitpod.io
2. Enable VS Code under settings at https://gitpod.io/settings
3. Open the repository using Gitpod by going to: https://gitpod.io/#https://github.com/purkhusid/bazel-bootstrap

By using Gitpod you get an ready to use development environment with the
correct plugins set up for each programming language

### Using remote execution

The repository is also ready for remote execution via [BuildBuddy](https://buildbuddy.io)
All you have to do is follow these steps:

1. Create an account at BuildBuddy: https://app.buildbuddy.io
2. Create an BuildBuddy API key under https://app.buildbuddy.io/settings/
3. Create a environment variable called `BUILDBUDDY_API_KEY` under your [gitpod settings](https://gitpod.io/settings) with the API key you got in the previous step
4. [Open this repository using Gitpod](https://gitpod.io/#https://github.com/purkhusid/bazel-bootstrap)
5. Run bazel using `--config=remote` e.g. `bazel build --config=remote //...`
