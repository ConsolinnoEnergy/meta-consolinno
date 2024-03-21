SUMMARY = "Sets hostname"
DESCRIPTION = "This service sets the hostname on boot based on the file /src/hostname"

LICENSE = "CLOSED"

inherit systemd

SRC_URI = "file://sethostname.service \
           file://set_hostname.sh \
           "

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/sethostname.service ${D}${systemd_unitdir}/system/
    install -D -p -m 0755 ${WORKDIR}/set_hostname.sh ${D}${sbindir}/set_hostname
}

FILES:${PN} += "\
    ${sbindir}/set_hostname \
    ${systemd_unitdir}/system/sethostname.service \
"
