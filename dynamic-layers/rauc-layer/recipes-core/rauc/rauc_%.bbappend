FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI:remove = "file://system.conf"
SRC_URI:append = "file://system.conf.in"

SED_SYSTEM_CONF = "\
    sed \
    -e 's!${'MACHINE'}!${MACHINE}!g' \
"

EXTERNAL_FILES += "\
    ${RAUC_KEYRING_URI} \
"

inherit external-file

do_expand_system_conf[dirs] = "${WORKDIR}"
do_expand_system_conf() {
    rm -f system.conf
    ${SED_SYSTEM_CONF} < system.conf.in > system.conf
}
do_unpack[postfuncs] += "do_expand_system_conf"

## rauc allows to customize an uri for the keyring but assumes a fixed
## name later.  Create a symbolic link so that downloaded file can be
## found later.
do_fixup_keyring[dirs] = "${WORKDIR}"
do_fixup_keyring() {
    if test x'${RAUC_KEYRING_URI}' = x'file://${RAUC_KEYRING_FILE}'; then
        : # noop; skip case when file has been downloaded with coorect
          # name already
    elif "${@'true' if d.getVar('RAUC_KEYRING_URI').startswith('file://') else 'false'}"; then
        f='${RAUC_KEYRING_URI}'
        f=${f##file://}

        rm -f '${WORKDIR}/${RAUC_KEYRING_FILE}'
        ln -sr "./$f" '${WORKDIR}/${RAUC_KEYRING_FILE}'
    fi
}
do_unpack[postfuncs] += "do_fixup_keyring"

RRECOMMENDS:${PN} += "dbus"
