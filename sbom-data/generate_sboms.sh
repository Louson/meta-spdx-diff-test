#!/bin/bash

: ${KAS:="kas"}
: ${KAS_EXTRA_YML:=""}

root_git_path="$(readlink -f "${BASH_SOURCE[0]}")"
root_git_path="$(dirname "$root_git_path")"
cd "$(dirname "$root_git_path")"

BUILD_SPDX_FILE="build/tmp-glibc/deploy/images/qemux86-64/core-image-minimal-qemux86-64.rootfs.spdx.json"

echo "****** Generating reference-sbom.spdx.json ******"
$KAS build "kas/image-minimal.yml${KAS_EXTRA_YML}"
cp "$BUILD_SPDX_FILE" sbom-data/reference-sbom.spdx.json

for kas_yml in kas/test-*.yml ; do
    kas_fn="${kas_yml##*/}"
    kas_fn="${kas_fn%.yml}"

    echo "****** Generating $kas_fn ******"
    $KAS build "kas/image-minimal.yml:${kas_yml}${KAS_EXTRA_YML}"

    cp "$BUILD_SPDX_FILE" "sbom-data/${kas_fn}.spdx.json"
done
