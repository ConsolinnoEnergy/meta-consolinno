LICENSE = "CLOSED"

ROOT_PASSWD_FILENAME ??= "root.passwd"

SRC_URI = "\
    file://${ROOT_PASSWD_FILENAME};subdir=_root \
"

inherit deploy

# add a dedicated 'do_compile' step to make sure that
# '${ROOT_PASSWD_FILENAME}' is expanded and accessed outside of
# 'pseudo'
do_compile() {
    cp '${WORKDIR}/_root/${ROOT_PASSWD_FILENAME}' '${B}/root.passwd'
}

do_deploy() {
    install -D -p -m 0644 '${B}/root.passwd' ${DEPLOYDIR}/root.passwd
}

addtask deploy before do_build after do_compile
