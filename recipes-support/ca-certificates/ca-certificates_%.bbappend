FILESEXTRAPATHS:prepend := "${THISDIR}/ca-certificates:"

SRC_URI += "\
    file://1u0022-image-ca.crt \
    file://ca-consolinno-root.crt \
    file://se-ca-chain.pem \
"

# Run this before the normal 'do_install()' because certificates must
# be registered in /etc/ca-certifactes.conf which is done at the end
# of the original task
do_install:prepend() {
    d='${D}${datadir}/ca-certificates'
    install -d "$d"

    install -p -m 0644 ${WORKDIR}/1u0022-image-ca.crt  "$d"/
    install -p -m 0644 ${WORKDIR}/ca-consolinno-root.crt "$d"/
    install -p -m 0644 ${WORKDIR}/se-ca-chain.pem "$d"/
}

# add machine specific certificates in extra package which is add to
# factory initrd
PACKAGE_BEFORE_PN += "${PN}-1u0022"

FILES:${PN}-1u0022 += "\
    ${datadir}/ca-certificates/1u0022-*.crt \
    ${datadir}/ca-certificates/ca-consolinno-root.crt \
    ${datadir}/ca-certificates/se-ca-chain.pem \
"

RDEPENDS:${PN} += "${PN}-1u0022 (= ${EXTENDPKGV})"
