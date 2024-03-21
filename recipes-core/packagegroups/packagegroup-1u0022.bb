## --*- bitbake -*--

PACKAGE_ARCH = "${MACHINE_ARCH}"

MACHINE_FIRMWARE_PROVIDER ??= ""

inherit packagegroup

RDEPENDS:${PN} += "\
    ${MACHINE_FIRMWARE_PROVIDER} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'rauc', 'rauc', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'ubifs', 'mtd-utils-ubifs', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'mtd', 'mtd-utils', '', d)} \
\
    iproute2 \
    ipset \
    iptables \
\
    1u0022-setup-system \
    1u0022-setup-hostname \
    lvm2 \
    e2fsprogs-resize2fs \
    mmc-utils \
"

RRECOMMENDS:${PN} += "\
    bash \
    coreutils \
    grep \
    gzip \
    kernel-modules \
    less \
    curl \
    bind-utils \
    tzdata-europe \
"
