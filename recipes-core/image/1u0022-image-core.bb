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
IMAGE_FEATURES += "${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'virtualization', '', d)}"
IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_FEATURES += "read-only-rootfs"

inherit core-image

IMAGE_INSTALL += "\
    packagegroup-core-boot \
    packagegroup-1u0022 \
"

PACKAGE_EXCLUDE_COMPLEMENTARY += "\
    dtc \
"

inherit extrausers

_EXTRA_USERS_PARAMS_release = "usermod -p '$(cat ${DEPLOY_DIR_IMAGE}/root.passwd)' root;"

EXTRA_USERS_PARAMS += "${@bb.utils.contains('DISTRO_FEATURES', 'release', d.getVar('_EXTRA_USERS_PARAMS_release'), '', d)}"

do_rootfs[depends] += "deploy-passwd:do_deploy"
