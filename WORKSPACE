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
    minimum_bazel_version = "4.0.0rc7",
    maximum_bazel_version = "4.0.0rc7",
)

#################################################################
# Protobuf
# The protobuf compiler
# This is used by various language toolchains to build protobuf
#################################################################
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "com_google_protobuf",
    sha256 = "bf0e5070b4b99240183b29df78155eee335885e53a8af8683964579c214ad301",
    strip_prefix = "protobuf-3.14.0",
    urls = ["https://github.com/protocolbuffers/protobuf/archive/v3.14.0.zip"],
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

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
    # See: https://github.com/bazelbuild/rules_scala#usage-with-bazel-deps
    override_targets = {
        "org.scala-lang:scala-library": "@io_bazel_rules_scala_scala_library//:io_bazel_rules_scala_scala_library",
        "org.scala-lang:scala-reflect": "@io_bazel_rules_scala_scala_reflect//:io_bazel_rules_scala_scala_reflect",
        "org.scala-lang:scala-compiler": "@io_bazel_rules_scala_scala_compiler//:io_bazel_rules_scala_scala_compiler",
        "org.scala-lang.modules:scala-parser-combinators": "@io_bazel_rules_scala_scala_parser_combinators//:io_bazel_rules_scala_scala_parser_combinators",
        "org.scala-lang.modules:scala-xml": "@io_bazel_rules_scala_scala_xml//:io_bazel_rules_scala_scala_xml",
    },
    fetch_sources = True,
    maven_install_json = "@monorepo//src:maven_install.json",
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
rules_scala_version = "cdaccd5fe4e13791b3df5770ffaf6f16463fa5c5"

http_archive(
    name = "io_bazel_rules_scala",
    sha256 = "b19603fabd7e7b2fa252146f6fe1c1e0c2761e8e036323a1795f36f35023d364",
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