"""
@generated
cargo-raze generated Bazel file.

DO NOT EDIT! Replaced on runs of cargo-raze
"""

load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")  # buildifier: disable=load
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")  # buildifier: disable=load
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")  # buildifier: disable=load

def raze_fetch_remote_crates():
    """This function defines a collection of repos and should be called in a WORKSPACE file"""
    maybe(
        http_archive,
        name = "raze__log__0_3_6",
        url = "https://crates.io/api/v1/crates/log/0.3.6/download",
        type = "tar.gz",
        sha256 = "ab83497bf8bf4ed2a74259c1c802351fcd67a65baa86394b6ba73c36f4838054",
        strip_prefix = "log-0.3.6",
        build_file = Label("//src/rust/cargo/remote:BUILD.log-0.3.6.bazel"),
    )
