## --*- bitbake -*--

inherit packagegroup

PACKAGES += "${PN}-debug"

RDEPENDS:${PN} += "\
    busybox \
    lvm2 \
    1u0022-setup-initrd \
"

RDEPENDS:${PN}-debug += "\
    1u0022-setup-debug \
    strace \
"
