## --*- bitbake -*--

inherit packagegroup

RRECOMMENDS:${PN} += "\
    devmem2 \
    ethtool \
    evtest \
    gdb \
    i2c-tools \
    iperf3 \
    iputils\
    ldd \
    lsof \
    ltrace \
    net-tools \
    openssl \
    procps \
    strace \
    util-linux \
    valgrind \
    tcpdump \
    systemd-analyze \
\
    file \
\
    ${@bb.utils.contains('DISTRO_FEATURES', 'pci', 'pciutils', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'usbhost', 'usbutils', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'nfs', 'nfs-utils nfs-utils-client', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'v4l2', 'v4l-utils', '', d)} \
"
