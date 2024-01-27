SUBPATH = "initrd"

require 1u0022-setup.inc

RDEPENDS:${PN} += "\
    bash \
    cryptsetup \
    lvm2 \
    tpm2-tools \
"
