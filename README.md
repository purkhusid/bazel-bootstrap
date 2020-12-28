# Bazel Bootstrap

This repository contains a bootstrapping template for various programming 
languages built with [Bazel](https://bazel.build)

All the programming languages implement the same gRPC service if the tooling
supports gRPC. Otherwise the language will implement a simple http web service.

# Prerequisites

TODO: List all prereqs and why they are needed

## Building and testing

All the code in the repository is built and tested using Bazel. Bazel is
bootstrapped using [bazelisk](https://github.com/bazelbuild/bazelisk) which is
included the the repository as `./bazel`.

You can therefore build and test the whole repository by running

```
./bazel test //...
```

## Supported languages

### Go

TODO: Explain setup

## IDE Setup
TODO: Set up Gitpod


## Interesting stuff to look at

* grpc-web
