SUMMARY = "Dummy proprietary tool (prebuilt binary)"
DESCRIPTION = "Example of packaging a closed-source binary with Yocto."
LICENSE = "Proprietary"
LICENSE_FLAGS = "commercial"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8751ca37decee9f0fef5ff8a49041a09"

SRC_URI = "file://my-proprietary-binary.tar.bz2"

S = "${WORKDIR}"

inherit update-alternatives

INSANE_SKIP:${PN} += "already-stripped"

do_install() {
    install -Dm0755 ${WORKDIR}/my-proprietary-binary ${D}${bindir}/my-proprietary
}

FILES:${PN} += "${bindir}/my-proprietary"
