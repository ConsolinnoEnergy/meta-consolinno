FILESEXTRAPATHS:prepend := "${THISDIR}/base-files:"

SRC_URI += "\
    file://fstab.1u0022 \
"

do_install:append() {
    cat ${WORKDIR}/fstab.1u0022 >> ${D}${sysconfdir}/fstab
    install -d -m 0100 ${D}/data
}
