## --*- bitbake -*--

BAREBOX_PASSWD_FILENAME ??= "passwd"

## barebox build system expects CONFIG_PASSWORD_DEFAULT to be the
## basename of a single file in the source tree.  No paths are allowed.
## Use an unique name for it.
BAREBOX_PASSWD_S_NAME = "passwd-oe-build"

## bitbake copies the whole path of file:// variables; place the
## passwd file (which can be referenced by an absolute path) in a
## temporary '_root' directory
SRC_URI += "\
    ${@'file://${BAREBOX_PASSWD_FILENAME};subdir=_root' if d.getVar('BAREBOX_PASSWD_FILENAME') else ''}\
"

EXTRA_OEMAKE_release += "\
    CONFIG_PASSWORD_DEFAULT='${BAREBOX_PASSWD_S_NAME}' \
"

EXTRA_OEMAKE += "${@bb.utils.contains('DISTRO_FEATURES', 'release', d.getVar('EXTRA_OEMAKE_release', False), '', d)}"

do_copy_passwd() {
    f='${WORKDIR}/_root/${BAREBOX_PASSWD_FILENAME}'
    d='${S}/${BAREBOX_PASSWD_S_NAME}'

    rm -f $d
    if test -f "$f"; then
        sed '/^[[:space:]]*#/d' "$f"
    fi > $d
}
addtask do_copy_passwd after do_unpack before do_configure
