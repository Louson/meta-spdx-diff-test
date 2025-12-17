meta-sbom-diff-test
===================

This Yocto layer provides tools and configurations for generating
SPDX SBOMs (Software Bill of Materials) and computing SPDX diffs
for images, kernel configs, and PACKAGECONFIG entries.

Layer Structure
---------------

```bash
conf/
    layer.conf                  - Layer configuration

kas/
    *.yml                        - KAS build configurations
    patches/                     - Patches for kernel, packages, or OE-core
    sbom-diff.yml                - KAS config to enable sbom-diff features

recipes-core/images/
    core-image-minimal.bbappend  - Inherits sbom-diff class

recipes-example/example/
    example_0.1.bb               - Sample recipe for testing
    files/                        - License and proprietary binaries
```

Features
--------

1. Generates SPDX 3.0 SBOMs for images.
2. Computes diffs between new and reference SPDX files.
3. Includes kernel config and PACKAGECONFIG in the diff.

Defaults
--------

- Target MACHINE: `qemux86-64`
- Default image: `core-image-minimal` (distroless mode)

Usage
-----

1. Run your build with KAS using `kas/image-minimal.yml` or other configs:

```bash
   $ kas build meta-sbom-diff-test/kas/image-minimal.yml
```

Ex. build with additional packages or custom versions:

```bash
   $ kas build \
        layers/meta-sbom-diff-test/kas/image-minimal.yml:\
        layers/meta-sbom-diff-test/kas/new-package.yml:\
```

This will:
   - Include the `new-package` recipe in the image.
   - Generate SPDX SBOMs and compute diffs automatically.

2. The SBOM diff task (`do_sbom_diff`) automatically runs for images
   that inherit the `sbom-diff` class.

3. Output:

   - Timestamped diff files: `<IMAGE_NAME>-<timestamp>.spdx-diff.json`
   - Latest symlink: `<IMAGE_NAME>.spdx-diff.json`

    Example of output after building kas/new-package.yml:
    ```bash
        $ cat build/tmp-glibc/deploy/images/qemux86-64/core-image-minimal-qemux86-64.rootfs.spdx-diff.json
        {
          "package_diff": {
            "added": {
              "example": "0.1",
              "i2c-tools": "4.4"
            },
            "removed": {},
            "changed": {}
          },
          "kernel_config_diff": {
            "added": {},
            "removed": {},
            "changed": {}
          },
          "packageconfig_diff": {
            "added": [],
            "removed": []
          }
        }
    ```

4. Default reference SPDX file:

  `file://reference-sbom.spdx.json`
   Can be overridden via `SPDX_REF_FILE` in a bbappend.
