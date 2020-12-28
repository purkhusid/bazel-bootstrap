#!/usr/bin/env bash
set -x
cd "$(git rev-parse --show-toplevel)"


library_targets=$(./bazel query --keep_going 'kind("go_proto_library rule", //src/proto/...)')

# Remove the generated part of the go.mod since it will be replaced 
# later in the script
gen_part_start=$(grep -n '// START OF GENERATED' go.mod | cut -d : -f 1)
gen_part_end=$(grep -n '// END OF GENERATED' go.mod | cut -d : -f 1)
if [[ -n "${gen_part_start}" ]] && [[ -n "${gen_part_end}" ]]; then
  sed -i "${gen_part_start}","${gen_part_end}"d go.mod
fi

# Mark the beginning of the generated part in the go.mod file
echo "// START OF GENERATED" >> go.mod

for target in ${library_targets}; do
  target_name=$(buildozer 'print name' "${target}")
  importpath=$(buildozer 'print importpath' "${target}")
  target_path="$(echo "${target//:/ }" | awk '{print $1}')"

  # Add the import statement for write_file if it does not already exist
  buildozer -k \
    'new_load @bazel_skylib//rules:write_file.bzl write_file' \
    "${target}"

  # We remove the target if it already exists
  buildozer -k \
    'delete' "${target_path}:write_gomodule"

  # Add the write_file target
  buildozer -k \
    'new write_file write_gomodule' "${target}"

  # Set the out path
  out_path="${target_name}_/${importpath}/go.mod"
  buildozer -k \
    "set out ${out_path}" "${target_path}:write_gomodule"
  sed -i "s|\[\"${out_path}\"]|\"${out_path}\"|" "${target_path#//}/BUILD.bazel"

  # We have to use sed because i could not figure out
  # how to add content with muiltiple words using buildozer 
  buildozer -k \
    'add content SED_ME' "${target_path}:write_gomodule"
  sed -i "s|SED_ME|module ${importpath}|" "${target_path#//}/BUILD.bazel"

  # Add a replace statement to the go.mod to that generated proto can be resolved by tooling
  echo "replace ${importpath} v0.0.0 => ./bazel-bin/${target_path#//}/${target_name}_/${importpath}" >> go.mod
done

# Mark the end of the generated part of the go.mod file
echo "// END OF GENERATED" >> go.mod
