LICENSE = "CLOSED"

do_install() {
    install -d -m 0755 ${D}${sysconfdir}
    touch -m 0644 ${D}${sysconfdir}/.debug-image
}
