LICENSE = "CLOSED"

SRC_URI = "\
    file://enc-passwd.c \
"

DEPENDS += "openssl"

EXTRA_OEMAKE = "\
    VPATH='${WORKDIR}' \
    CFLAGS='${CFLAGS} -std=gnu99' \
    LDLIBS='-lcrypto' \
"

do_compile() {
	oe_runmake enc-passwd
}

do_install() {
	install -D -p -m 0755 enc-passwd ${D}${bindir}/barebox-enc-passwd
}
addtask do_install after do_compile before do_package

BBCLASSEXTEND = "native nativesdk"
