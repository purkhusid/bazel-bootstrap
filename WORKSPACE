# Declares that this directory is the root of a Bazel workspace.
# See https://docs.bazel.build/versions/master/build-ref.html#workspace
workspace(
    # How this workspace would be referenced with absolute labels from another workspace
    name = "monorepo",
    # This lets Bazel use the same node_modules as other local tooling.
    managed_directories = {
        "@npm": ["src/typescript/node_modules"],
    },
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

##############################################
# Bazel skylib
# Used for various convenience functionality
##############################################
http_archive(
    name = "bazel_skylib",
    sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
    urls = [
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

load("@bazel_skylib//lib:versions.bzl", "versions")

versions.check(
    minimum_bazel_version = "4.0.0",
    maximum_bazel_version = "4.0.0",
)

http_archive(
    name = "rules_proto",
    sha256 = "8e7d59a5b12b233be5652e3d29f42fba01c7cbab09f6b3a8d0a57ed6d1e9a0da",
    strip_prefix = "rules_proto-7e4afce6fe62dbff0a4a03450143146f9f2d7488",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/7e4afce6fe62dbff0a4a03450143146f9f2d7488.tar.gz",
        "https://github.com/bazelbuild/rules_proto/archive/7e4afce6fe62dbff0a4a03450143146f9f2d7488.tar.gz",
    ],
)

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

rules_proto_dependencies()

rules_proto_toolchains()

######################################################################
# 3rdparty support for jvm
# Support for 3rdparty libraries for JVM languages is provided by
# rules_jvm_external: https://github.com/bazelbuild/rules_jvm_external
#######################################################################
rules_jvm_git_hash = "b38b5a46c4309041a039a9c1b611f74202025c34"

http_archive(
    name = "rules_jvm_external",
    sha256 = "9269a84a81817eb8338d08a13c39511b44f26b2d1e62d5a62bf60dc79e1d3219",
    strip_prefix = "rules_jvm_external-%s" % rules_jvm_git_hash,
    type = "zip",
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % rules_jvm_git_hash,
)

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "io.grpc:grpc-api:1.24.0",
        "io.grpc:grpc-core:1.24.0",
        "io.grpc:grpc-netty:1.24.0",
        "io.grpc:grpc-protobuf:1.24.0",
        "io.grpc:grpc-stub:1.24.0",
    ],
    fetch_sources = True,
    maven_install_json = "@monorepo//src:maven_install.json",
    # See: https://github.com/bazelbuild/rules_scala#usage-with-bazel-deps
    override_targets = {
        "org.scala-lang:scala-library": "@io_bazel_rules_scala_scala_library//:io_bazel_rules_scala_scala_library",
        "org.scala-lang:scala-reflect": "@io_bazel_rules_scala_scala_reflect//:io_bazel_rules_scala_scala_reflect",
        "org.scala-lang:scala-compiler": "@io_bazel_rules_scala_scala_compiler//:io_bazel_rules_scala_scala_compiler",
        "org.scala-lang.modules:scala-parser-combinators": "@io_bazel_rules_scala_scala_parser_combinators//:io_bazel_rules_scala_scala_parser_combinators",
        "org.scala-lang.modules:scala-xml": "@io_bazel_rules_scala_scala_xml//:io_bazel_rules_scala_scala_xml",
    },
    repositories = [
        "https://jcenter.bintray.com/",
        "http://uk.maven.org/maven2",
        "https://maven.google.com",
        "https://repo1.maven.org/maven2",
    ],
    strict_visibility = True,
    version_conflict_policy = "pinned",
)

load("@maven//:defs.bzl", "pinned_maven_install")

pinned_maven_install()

#############################################################
# Go
# Go language support is provided with
# rules_go: https://github.com/bazelbuild/rules_go
# bazel-gazelle: https://github.com/bazelbuild/bazel-gazelle
#
# rules_go provides the basic Go language support while
# bazel-gazelle provides 3rd party library support and
# BUILD file generation
#############################################################
http_archive(
    name = "io_bazel_rules_go",
    sha256 = "7904dbecbaffd068651916dce77ff3437679f9d20e1a7956bff43826e7645fcc",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.25.1/rules_go-v0.25.1.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.25.1/rules_go-v0.25.1.tar.gz",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "222e49f034ca7a1d1231422cdb67066b885819885c356673cb1f72f748a3c9d4",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.3/bazel-gazelle-v0.22.3.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.3/bazel-gazelle-v0.22.3.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.15.5")

gazelle_dependencies()

load("//src/go:godeps_macro.bzl", "go_repositories")

# gazelle:repository_macro src/go/godeps_macro.bzl%go_repositories
go_repositories()

###########################################
# Scala
# Scala language support is provided with
# rules_scala:
###########################################
rules_scala_version = "939fa4cb85654d212d3649060215afb95f3f6dbd"

http_archive(
    name = "io_bazel_rules_scala",
    sha256 = "4afe9e13af5f867584a51f51f1c18065ca4a6611165df3312e41e711865591ca",
    strip_prefix = "rules_scala-%s" % rules_scala_version,
    type = "zip",
    url = "https://github.com/bazelbuild/rules_scala/archive/%s.zip" % rules_scala_version,
)

# Stores Scala version and other configuration
# 2.12 is a default version, other versions can be use by passing them explicitly:
# scala_config(scala_version = "2.11.12")
load("@io_bazel_rules_scala//:scala_config.bzl", "scala_config")

scala_config("2.12.10")

load("@io_bazel_rules_scala//scala:scala.bzl", "scala_repositories")

scala_repositories()

load("@io_bazel_rules_scala//scala:toolchains.bzl", "scala_register_toolchains")

scala_register_toolchains()

# optional: setup ScalaTest toolchain and dependencies
load("@io_bazel_rules_scala//testing:scalatest.bzl", "scalatest_repositories", "scalatest_toolchain")

scalatest_repositories()

scalatest_toolchain()

load("@io_bazel_rules_scala//scala_proto:scala_proto.bzl", "scala_proto_repositories")

scala_proto_repositories()

register_toolchains("//src/scala:scalapb_toolchain")

####################################################################################################
# NodeJS
# Javascript/Typescript support is provided by
# rules_nodejs for language support: https://github.com/bazelbuild/rules_nodejs
# rules_typescript_proto for proto/gRPC support: https://github.com/Dig-Doug/rules_typescript_proto
####################################################################################################
http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "6142e9586162b179fdd570a55e50d1332e7d9c030efd853453438d607569721d",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/3.0.0/rules_nodejs-3.0.0.tar.gz"],
)

load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories", "yarn_install")

node_repositories(package_json = ["//src/typescript:package.json"])

yarn_install(
    name = "npm",
    package_json = "//src/typescript:package.json",
    yarn_lock = "//src/typescript:yarn.lock",
)

# NOTE: Using fork until https://github.com/Dig-Doug/rules_typescript_proto/pull/140 is merged
http_archive(
    name = "rules_typescript_proto",
    # sha256 = "aac6dec2c8d55da2b2c2689b7a2afe44b691555cab32e2eaa2bdd29627d950e9",
    strip_prefix = "rules_typescript_proto-47cd22cc6b7ec7e53b7a77970714b1af07f79449",
    urls = [
        "https://github.com/purkhusid/rules_typescript_proto/archive/47cd22cc6b7ec7e53b7a77970714b1af07f79449.tar.gz",
    ],
)

load("@rules_typescript_proto//:index.bzl", "rules_typescript_proto_dependencies")

rules_typescript_proto_dependencies()

#######################################################
# Rust
# Rust support is provided by
# rules_rust for language support: https://github.com/bazelbuild/rules_rust
# cargo-raze for 3rdparty dependencies: https://github.com/google/cargo-raze
#######################################################
# NOTE: Using this fork until https://github.com/bazelbuild/rules_rust/pull/505 has been merged
http_archive(
    name = "io_bazel_rules_rust",
    sha256 = "0281a8240c8ac0d831da08addcdb22f47a22ddc2f22a4dc1c8fddd71f2195386",
    strip_prefix = "rules_rust-a0df8c5d9cfa128a98b6bd84fa187b36b04f6a62",
    urls = [
        "https://github.com/djmarcin/rules_rust/archive/a0df8c5d9cfa128a98b6bd84fa187b36b04f6a62.tar.gz",
    ],
)

load("@io_bazel_rules_rust//rust:repositories.bzl", "rust_repositories")
load("@io_bazel_rules_rust//proto:repositories.bzl", "rust_proto_repositories")

rust_repositories()
rust_proto_repositories()

load("//src/rust/cargo:crates.bzl", "raze_fetch_remote_crates")

raze_fetch_remote_crates()

######################################################
# Set up Remote execution toolchain using BuildBuddy
######################################################
http_archive(
    name = "io_buildbuddy_buildbuddy_toolchain",
    sha256 = "9055a3e6f45773cd61931eba7b7cf35d6477ab6ad8fb2f18bf9815271fc682fe",
    strip_prefix = "buildbuddy-toolchain-52aa5d2cc6c9ba7ee4063de35987be7d1b75f8e2",
    urls = ["https://github.com/buildbuddy-io/buildbuddy-toolchain/archive/52aa5d2cc6c9ba7ee4063de35987be7d1b75f8e2.tar.gz"],
)

load("@io_buildbuddy_buildbuddy_toolchain//:deps.bzl", "buildbuddy_deps")

buildbuddy_deps()

load("@io_buildbuddy_buildbuddy_toolchain//:rules.bzl", "buildbuddy")

buildbuddy(name = "buildbuddy_toolchain")
