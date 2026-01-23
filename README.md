# meta-sbom-diff-test

Test layer demonstrating sbom-diff with various SBOM change scenarios.

## Structure

- `core-image-minimal.bbappend` - Enables sbom-diff with fixed reference SBOM
- `kas/image-minimal.yml` - Builds baseline core-image-minimal
- `kas/*.yml` - Test scenarios that compose with image-minimal.yml
- `recipes-example/example/` - Demo package for testing
- `kernel-config/*.cfg` - Kernel configuration test cases

## Test Scenarios

### Package Changes
- `new-package.yml` - Add packages (example, i2c-tools)
- `new-package-version.yml` - Upgrade i2c-tools (4.3 → 4.4)
- `new-packageconfig.yml` - Modify package build features

### Kernel Configuration (Safe)
- `kernelconfig-y-to-n.yml` - Disable built-in (y → n)
- `kernelconfig-m-to-n.yml` - Disable module (m → n)
- `kernelconfig-y-to-m.yml` - Modularize (y → m)
- `kernelconfig-m-to-y.yml` - Make built-in (m → y)

### Kernel Configuration (Breaking)
- `kernelconfig-n-to-y.yml` - Enable feature (n → y)
- `kernelconfig-n-to-m.yml` - Enable module (n → m)

## Quick Start

```bash
# Clone
git clone https://github.com/bootlin/meta-sbom-diff-test layers/meta-sbom-diff-test

# Build baseline
kas build layers/meta-sbom-diff-test/kas/image-minimal.yml

# Build with changes
kas build layers/meta-sbom-diff-test/kas/image-minimal.yml:layers/meta-sbom-diff-test/kas/new-package.yml

# View diff
cat build/tmp-glibc/deploy/images/qemux86-64/core-image-minimal-qemux86-64.rootfs.spdx-diff.json
```

## How It Works

1. `core-image-minimal.bbappend` inherits sbom-diff class
2. Reference SBOM is fetched from:
   ```
   https://raw.githubusercontent.com/bootlin/sbom-diff/main/tests/reference-sbom.spdx.json
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

```bash
# Package tests
kas build kas/image-minimal.yml:kas/new-package.yml
kas build kas/image-minimal.yml:kas/new-package-version.yml
kas build kas/image-minimal.yml:kas/new-packageconfig.yml

# Kernel config tests (safe - no warnings)
kas build kas/image-minimal.yml:kas/kernelconfig-y-to-n.yml
kas build kas/image-minimal.yml:kas/kernelconfig-m-to-y.yml

# Kernel config tests (breaking - expect warnings)
kas build kas/image-minimal.yml:kas/kernelconfig-n-to-y.yml
kas build kas/image-minimal.yml:kas/kernelconfig-n-to-m.yml
```

## Requirements

- [meta-sbom-diff](https://github.com/bootlin/meta-sbom-diff)
- Scarthgap with OE-Core commit a172a0e8d5 or later
- KAS build tool

## Links

- sbom-diff tool: https://github.com/bootlin/sbom-diff
- meta-sbom-diff layer: https://github.com/bootlin/meta-sbom-diff
