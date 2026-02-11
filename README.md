# meta-sbom-diff-test

Test layer demonstrating sbom-diff with various SBOM change scenarios.

## Structure

- `core-image-minimal.bbappend` - Enables sbom-diff with fixed reference SBOM
- `kas/image-minimal.yml` - Builds baseline core-image-minimal
- `kas/sbom-diff.yml` - Enables sbom-diff with fixed reference SBOM by applying
  `meta-sbom-diff-test/recipes-core/images/core-image-minimal.bbappend`.
- `kas/test-*.yml` - Test scenarios that compose with image-minimal.yml
- `meta-recipes-test/` - Demo layer providing packages for testing
- `kernel-config/*.cfg` - Kernel configuration test cases

## Test Scenarios

### Package Changes

- `test-new-package.yml` - Add packages (example, i2c-tools)
- `test-new-package-version.yml` - Upgrade i2c-tools (4.3 → 4.4)
- `test-new-packageconfig.yml` - Modify package build features

### Kernel Configuration

- `test-kernelconfig-n-to-y.yml` - Enable feature (n → y)
- `test-kernelconfig-n-to-m.yml` - Enable module (n → m)

## Quick Start

```bash
# Clone
git clone https://github.com/bootlin/meta-sbom-diff-test.git meta-sbom-diff-test*
cd meta-sbom-diff-test

# Build baseline
kas build kas/image-minimal.yml

# Build with changes
kas build kas/image-minimal.yml:kas/new-package.yml

# Build with changes and with sbom-diff enabled
kas build kas/image-minimal.yml:kas/sbom-diff.yml:kas/new-package.yml

# View diff
cat build/tmp-glibc/deploy/images/qemux86-64/core-image-minimal-qemux86-64.rootfs.spdx-diff.json
```

## How It Works

1. `core-image-minimal.bbappend` inherits sbom-diff class
2. Reference SBOM is fetched from:
   ```
   file://${TOPDIR}/../sbom-data/reference-sbom.spdx.json
   ```
3. After image build, sbom-diff compares new vs reference
4. Diff results are deployed with human-readable summary

## Example Output

```
Packages - Added:
    + example: 0.1
    + i2c-tools: 4.3

Packages - Changed:
    ~ openssl: 3.0.13 -> 3.0.14

Kernel Config - Changed:
    ~ CONFIG_SECURITY_SELINUX: n -> y
```

## Test Composition

All scenarios compose with `image-minimal.yml`:

To generate all test cases, executes: `sbom-data/generate_sboms.sh`

## Requirements

- [meta-sbom-diff](https://github.com/bootlin/meta-sbom-diff)
- Scarthgap with OE-Core commit a172a0e8d5 or later
- KAS build tool

## Links

- sbom-diff tool: https://github.com/bootlin/sbom-diff
- meta-sbom-diff layer: https://github.com/bootlin/meta-sbom-diff
