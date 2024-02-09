SUBPATH = "initrd"

require 1u0022-setup.inc

RDEPENDS:${PN} += "\
    bash \
    cryptsetup \
    lvm2 \
    tpm2-tools \
    util-linux-switch-root \
"

do_install:append() {
	install -m 0400 /dev/null ${D}${sysconfdir}/preliminary-key
	echo '${TPM_DEV_SECRET}' > ${D}${sysconfdir}/preliminary-key
}
