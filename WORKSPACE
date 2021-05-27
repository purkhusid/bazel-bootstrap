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
RULES_JVM_EXTERNAL_TAG = "4.1"
RULES_JVM_EXTERNAL_SHA = "f36441aa876c4f6427bfb2d1f2d723b48e9d930b62662bf723ddfb8fc80f0140"

http_archive(
    name = "rules_jvm_external",
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    sha256 = RULES_JVM_EXTERNAL_SHA,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
)

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    fail_if_repin_required = True,
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
    sha256 = "69de5c704a05ff37862f7e0f5534d4f479418afc21806c887db544a316f3cb6b",
    urls = [
        "https://github.com/bazelbuild/rules_go/releases/download/v0.27.0/rules_go-v0.27.0.tar.gz",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "62ca106be173579c0a167deb23358fdfe71ffa1e4cfdddf5582af26520f1c66f",
    urls = [
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.16.2")

gazelle_dependencies()

load("//src/go:godeps_macro.bzl", "go_repositories")

# gazelle:repository_macro src/go/godeps_macro.bzl%go_repositories
go_repositories()

###########################################
# Scala
# Scala language support is provided with
# rules_scala:
###########################################
rules_scala_version = "c9cc7c261d3d740eb91ef8ef048b7cd2229d12ec"

http_archive(
    name = "io_bazel_rules_scala",
    sha256 = "8887906c9698a63f7ebf30498050fee695d7fdc70b0ee084fece549cbe922159",
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
    sha256 = "4a5d654a4ccd4a4c24eca5d319d85a88a650edf119601550c95bf400c8cc897e",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/3.5.1/rules_nodejs-3.5.1.tar.gz"],
)

load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories", "yarn_install")

node_repositories(package_json = ["//src/typescript:package.json"])

yarn_install(
    name = "npm",
    package_json = "//src/typescript:package.json",
    yarn_lock = "//src/typescript:yarn.lock",
)

http_archive(
    name = "rules_typescript_proto",
    sha256 = "6675ca265f2948a585cea9bac75be1eb983b3e23a64d715915759918ae9e4260",
    strip_prefix = "rules_typescript_proto-96a4ae2ad0eb9770e9d71ae29d34d5b871719a96",
    urls = [
        "https://github.com/Dig-Doug/rules_typescript_proto/archive/96a4ae2ad0eb9770e9d71ae29d34d5b871719a96.tar.gz",
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
    name = "rules_rust",
    sha256 = "fdafd94c2161e028c8d258d276d26372a45428b1f023f6dcfd1dd831cd5bd18d",
    strip_prefix = "rules_rust-7458499d76cd7622171e1fe248a254f89cdefc1f",
    urls = [
        "https://github.com/bazelbuild/rules_rust/archive/7458499d76cd7622171e1fe248a254f89cdefc1f.tar.gz",
    ],
)

load("@rules_rust//rust:repositories.bzl", "rust_repositories")
load("@rules_rust//proto:repositories.bzl", "rust_proto_repositories")

rust_repositories(version = "1.52.0", edition="2018", rustfmt_version = "1.52.0", include_rustc_srcs = True)

rust_proto_repositories()

load("//src/rust/cargo:crates.bzl", "raze_fetch_remote_crates")

raze_fetch_remote_crates()

load("@rules_rust//tools/rust_analyzer:deps.bzl", "rust_analyzer_deps")

rust_analyzer_deps()

#######################################################
# .Net
# .Net support is provided by
# rules_dotnet for language support: https://github.com/bazelbuild/rules_dotnet
# cargo-raze for 3rdparty dependencies: https://github.com/google/cargo-raze
#######################################################
http_archive(
    name = "io_bazel_rules_dotnet",
    sha256 = "33b35e13e8d41f8a44e88af79734e691219f392655141b83ae38238d7692d8e1",
    strip_prefix = "rules_dotnet-64ad7481bae1052ed775c3642e4fa146c5a4cdd1",
    urls = [
        "https://github.com/bazelbuild/rules_dotnet/archive/64ad7481bae1052ed775c3642e4fa146c5a4cdd1.tar.gz",
    ],
)

load("@io_bazel_rules_dotnet//dotnet:deps.bzl", "dotnet_repositories")

dotnet_repositories()

load("@io_bazel_rules_dotnet//dotnet:defs.bzl", "dotnet_register_toolchains", "dotnet_repositories_nugets")

dotnet_register_toolchains()

dotnet_repositories_nugets()

load("//src/dotnet/nuget:nuget.bzl", "nuget_packages")

nuget_packages()

#################################################################################################################
# Protobuf/gRPC support for various languages that don't have builtin support
# NOTE: using fork until this PR has been merged: https://github.com/rules-proto-grpc/rules_proto_grpc/pull/110
#################################################################################################################
http_archive(
    name = "rules_proto_grpc",
    sha256 = "a67a399b8607511874b0b893371ea05524345d8a55b698571baa2477f16433e1",
    strip_prefix = "rules_proto_grpc-e118d854158cf59897259b7dd44522929ec64d2b",
    urls = ["https://github.com/rules-proto-grpc/rules_proto_grpc/archive/e118d854158cf59897259b7dd44522929ec64d2b.tar.gz"],
)

load("@rules_proto_grpc//:repositories.bzl", "rules_proto_grpc_repos", "rules_proto_grpc_toolchains")

rules_proto_grpc_toolchains()

rules_proto_grpc_repos()

load("@rules_proto_grpc//csharp:repositories.bzl", rules_proto_grpc_csharp_repos="csharp_repos")

rules_proto_grpc_csharp_repos()

load("@rules_proto_grpc//fsharp:repositories.bzl", rules_proto_grpc_fsharp_repos="fsharp_repos")

rules_proto_grpc_fsharp_repos()

load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", "grpc_deps")

grpc_deps()

######################################################
# Set up Remote execution toolchain using BuildBuddy
######################################################
http_archive(
    name = "io_buildbuddy_buildbuddy_toolchain",
    sha256 = "a2a5cccec251211e2221b1587af2ce43c36d32a42f5d881737db3b546a536510",
    strip_prefix = "buildbuddy-toolchain-829c8a574f706de5c96c54ca310f139f4acda7dd",
    urls = ["https://github.com/buildbuddy-io/buildbuddy-toolchain/archive/829c8a574f706de5c96c54ca310f139f4acda7dd.tar.gz"],
)

load("@io_buildbuddy_buildbuddy_toolchain//:deps.bzl", "buildbuddy_deps")

buildbuddy_deps()

load("@io_buildbuddy_buildbuddy_toolchain//:rules.bzl", "buildbuddy")

buildbuddy(name = "buildbuddy_toolchain")
