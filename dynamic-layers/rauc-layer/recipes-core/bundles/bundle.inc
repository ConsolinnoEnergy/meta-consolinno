## --*- bitbake -*--

LICENSE = "CLOSED"

inherit bundle
inherit external-file

SRC_URI += "\
    file://hook.sh \
"

PV = "${DISTRO_VERSION}"

EXTERNAL_FILES += "\
    ${L1U0022_RAUC_KEY_FILE} \
    ${L1U0022_RAUC_CRT_FILE} \
"

RAUC_BUNDLE_COMPATIBLE = "${MACHINE}"
RAUC_BUNDLE_DESCRIPTION = "${L1U0022_BASE_IMG} bundle"

RAUC_BUNDLE_SLOTS = "rootfs fitimage"
RAUC_BUNDLE_FORMAT = "verity"

RAUC_BUNDLE_HOOKS[file] = "hook.sh"
RAUC_BUNDLE_HOOKS[hooks] = "install-check"

RAUC_KEY_FILE = "${L1U0022_RAUC_KEY_FILE}"
RAUC_CERT_FILE = "${L1U0022_RAUC_CRT_FILE}"

RAUC_SLOT_rootfs = "${L1U0022_BASE_IMG}"
RAUC_SLOT_rootfs[type] = "image"
RAUC_SLOT_rootfs[fstype] = "ext4"

RAUC_SLOT_fitimage = "${L1U0022_INITRD_RECIPE}"
RAUC_SLOT_fitimage[hooks] = "pre-install;post-install"
RAUC_SLOT_fitimage[type] = "kernel"
RAUC_SLOT_fitimage[file] = "${L1U0022_INITRD_IMG}"
RAUC_SLOT_fitimage[fstype] = "raw"
RAUC_SLOT_fitimage[rename] = "${MACHINE}.fit.img"
