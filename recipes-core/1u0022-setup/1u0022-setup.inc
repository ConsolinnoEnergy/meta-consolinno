LICENSE = "CLOSED"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI = "${@l1u0022_internal_component_uri(d, '1u0022-setup')}"
SRCREV  = "ab5e54ede3e5b1f53239a0ce829b873584d021cc"

inherit 1u0022-internal-component
inherit features_check

REQUIRED_DISTRO_FEATURES = "usrmerge"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = "\
    srcdir='${S}' \
    SUBDIRS='common ${SUBPATH}' \
"

do_install() {
	oe_runmake install DESTDIR=${D}

	install -d -m 0755 ${D}${sysconfdir}
	echo '${MACHINE}' > ${D}${sysconfdir}/machine
}

ALLOW_EMPTY:${PN} = "1"

FILES:${PN} = "/*"
