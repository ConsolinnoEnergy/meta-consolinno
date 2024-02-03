# --*- bitbake -*--

PACKAGE_ARCH = "${MACHINE_ARCH}"

BAREBOX_REVISION ??= "${SRCREV_barebox_${BASE_PV}}"
PROVIDES = "virtual/bootloader"

BAREBOX_DEFCONFIG ??= "${WORKDIR}/defconfig"
KCONFIG_DEFCONFIG = "${BAREBOX_DEFCONFIG}"

BAREBOX_DEPLOY_NAME ??= "barebox"
BAREBOX_IMG_TYPES ??= ".img"
BAREBOX_IMG_TYPES[type] = "list"

inherit kernel-arch elito-kconfig

unset CFLAGS
unset LDFLAGS

# to be overridden in .bbappend
COMPATIBLE_MACHINE  = "(-)"
IMGBASE ??= "${MACHINE}"

EXTRA_OEMAKE += "\
    -C ${S} \
    KBUILD_OUTPUT=${B} V=1 \
    CROSS_COMPILE='${TARGET_PREFIX}' \
    CC='${KERNEL_CC}' \
    LD='${KERNEL_LD}' \
    HOSTLDFLAGS='${BUILD_LDFLAGS}' \
    HOSTCC='${BUILD_CC}' \
    HOSTCFLAGS='${BUILD_CFLAGS}' \
    HOSTCXX='${BUILD_CXX}' \
    HOSTCXXFLAGS='${BUILD_CXXFLAGS}' \
    HOSTCPP='${BUILD_CPP} ${BUILD_CPPFLAGS}' \
"

inherit pkgconfig

export PKG_CONFIG_DIR    = "${STAGING_DIR_NATIVE}${libdir_native}/pkgconfig"
export PKG_CONFIG_PATH   = "${PKG_CONFIG_DIR}:${STAGING_DATADIR_NATIVE}/pkgconfig"
export PKG_CONFIG_LIBDIR = "${PKG_CONFIG_DIR}"
export PKG_CONFIG_SYSROOT_DIR = ""

## usage: _run_install <dst-dir>
_run_install() {
        local s=${B}/barebox
        local t=${BAREBOX_DEPLOY_NAME}-${IMGBASE}-${PV}-${PR}.elf
        local l=${BAREBOX_DEPLOY_NAME}-${IMGBASE}.elf

	install -D -p -m 0644 "$s" "$1/$t"
	ln -sf "$t" "$1/$l"
	ln -sf "$l" "$1"/${BAREBOX_DEPLOY_NAME}.elf

	for img in ${@oe.data.typed_value("BAREBOX_IMG_TYPES", d)}; do
	    first=
	    for b in ${IMGBASE}; do
		test -n "$first" || first=${BAREBOX_DEPLOY_NAME}-$b-${PV}-${PR}
		s=${B}/images/barebox-$b$img
                t=${BAREBOX_DEPLOY_NAME}-$b-${PV}-${PR}$img
		l=${BAREBOX_DEPLOY_NAME}-$b$img

		install -p -m 0644 "$s" "$1/$t"
		ln -sf "$t" "$1/$l"
	    done

	    ln -sf "$first"$img                          "$1"/${BAREBOX_DEPLOY_NAME}$img
	done
}

inherit deploy

do_deploy() {
	_run_install "${DEPLOYDIR}"
}
addtask do_deploy before do_build after do_compile
