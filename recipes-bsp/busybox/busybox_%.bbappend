FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

## disable syslogd + klogd when systemd is used.  It steals /dev/log
## from journald and creates an extra /var/log/messages file which
## must be rotated manually

SRC_URI:remove = "${@bb.utils.contains('DISTRO_FEATURES','systemd', 'syslog.cfg', '', d)}"
SRC_URI += "\
    ${@bb.utils.contains('DISTRO_FEATURES','systemd', 'file://no-syslog.cfg', '', d)} \
"

SYSTEMD_SERVICE:${PN}-syslog = ""
