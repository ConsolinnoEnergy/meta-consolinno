SUMMARY = "Sets hostname"
DESCRIPTION = "This service sets the hostname on boot based on the file /src/hostname"

LICENSE = "MIT"

SRC_URI = "file://sethostname.service \
           file://set_hostname.sh \
           "

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/sethostname.service ${D}${systemd_unitdir}/system/
    install -m 0755 ${WORKDIR}/set_hostname.sh ${D}${bindir}/
}

FILES_${PN} += "${systemd_unitdir}/system/sethostname.service"
