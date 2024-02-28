LICENSE = "CLOSED"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI = "${@l1u0022_internal_component_uri(d, '1u0022-setup')}"
SRCREV  = "581a83c83ded31601471190a18f2f1b89920f7f7"

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

TPM_DEV_SECRET = "!!!RemoveMe!!!OnlyForDevelopment!!!"
