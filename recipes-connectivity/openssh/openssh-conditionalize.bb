LICENSE = "CLOSED"

SRC_URI = "\
    file://ena-flag.conf \
"

inherit allarch

do_install() {
    for s in sshd.service sshd.socket; do
        install -D -p -m 0644 ${WORKDIR}/ena-flag.conf ${D}${systemd_system_unitdir}/$s.d/ena-flag.conf
    done
}

FILES:${PN} += "\
    ${systemd_system_unitdir}/*.d/*.conf \
"
