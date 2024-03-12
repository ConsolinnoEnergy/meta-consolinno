FILESEXTRAPATHS:prepend := "${THISDIR}/ca-certificates:"

SRC_URI += "\
    file://1u0022-top-ca.crt \
    file://1u0022-image-ca.crt \
    file://1u0022-config-ca.crt \
    file://ca-consolinno-root.crt \
"

# Run this before the normal 'do_install()' because certificates must
# be registered in /etc/ca-certifactes.conf which is done at the end
# of the original task
do_install:prepend() {
    d='${D}${datadir}/ca-certificates'
    install -d "$d"

    install -p -m 0644 ${WORKDIR}/1u0022-top-ca.crt    "$d"/
    install -p -m 0644 ${WORKDIR}/1u0022-image-ca.crt  "$d"/
    install -p -m 0644 ${WORKDIR}/1u0022-config-ca.crt "$d"/
    install -p -m 0644 ${WORKDIR}/ca-consolinno-root.crt "$d"/
}

# add machine specific certificates in extra package which is add to
# factory initrd
PACKAGE_BEFORE_PN += "${PN}-1u0022"

FILES:${PN}-1u0022 += "\
    ${datadir}/ca-certificates/1u0022-*.crt \
    ${datadir}/ca-certificates/ca-consolinno-root.crt \
"

RDEPENDS:${PN} += "${PN}-1u0022 (= ${EXTENDPKGV})"
