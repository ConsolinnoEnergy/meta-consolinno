SUBPATH = "factory"

require 1u0022-setup.inc

RDEPENDS:${PN} += "\
    bash \
    busybox \
    busybox-udhcpc \
    ca-certificates-1u0022 \
    coreutils \
    cryptsetup \
    e2fsprogs-mke2fs \
    e2fsprogs-resize2fs \
    lvm2 \
    mmc-utils \
    openssl-bin \
    rauc \
    tpm2-tools \
    util-linux-sfdisk \
    util-linux-wipefs \
"
