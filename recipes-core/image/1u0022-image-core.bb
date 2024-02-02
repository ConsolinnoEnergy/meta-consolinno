require 1u0022-common.inc

IMAGE_FSTYPES = "ext4 tar.gz"

L1U0022_ROOTPART_SIZE_RAUC = "512M"
L1U0022_PERSIST_SIZE = "1024M"

DEPENDS += "\
    virtual/bootloader \
    virtual/kernel \
    coreutils-native \
"

IMAGE_FEATURES += "${@bb.utils.contains('MACHINE_FEATURES', 'tpm', 'tpm2 tpm2-device', '', d)}"
IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_FEATURES += "read-only-rootfs"
IMAGE_FEATURES += "virtualization"

inherit core-image

IMAGE_INSTALL += "\
    packagegroup-core-boot \
    packagegroup-1u0022 \
"

PACKAGE_EXCLUDE_COMPLEMENTARY += "\
    dtc \
"
