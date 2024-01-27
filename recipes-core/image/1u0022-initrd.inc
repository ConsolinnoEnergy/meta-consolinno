## --*- bitbake -*--

LICENSE = "CLOSED"

IMAGE_FSTYPES = "cpio.gz"

inherit core-image

IMAGE_LINGUAS = ""
IMAGE_INSTALL = ""

IMAGE_FEATURES += "${@bb.utils.contains('MACHINE_FEATURES', 'tpm', 'tpm2-device', '', d)}"

# this overrides value from 1u0022-common.inc
FEATURE_PACKAGES_debug-tweaks = "\
    packagegroup-1u0022-initrd-debug \
"

BAD_RECOMMENDATIONS += "\
    busybox-udhcpc \
    ncurses-terminfo-base \
    lvm2-scripts \
    lvm2-udevrules \
"
