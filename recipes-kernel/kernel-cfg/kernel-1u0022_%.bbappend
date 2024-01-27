FILESEXTRAPATHS:prepend := "${THISDIR}/kernel-1u0022-${BASE_PV}:${THISDIR}/features:"

DEPENDS += "lzop-native linux-firmware"

KCONFIG_DEFCONFIG = "${S}/arch/arm/configs/imx_v6_v7_defconfig"

_YES_NO_FEATURES ??= "initrd rauc/initrd tpm tpm/hw spi"

_CFGSET_COMMON = ""

_CFGSET_COMMON[vardeps] += "_ANY_FEATURES"
_CFGSET_COMMON = "\
    file://optimize.cfg \
    ${@_expand_yes_no(d, False)} \
    file://cpu.cfg \
    file://platform.cfg \
    file://hw.cfg \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd',   'file://systemd.cfg',   '', d)} \
    ${@_expand_yes_no(d, True)} \
    file://boot.cfg \
    file://iptables.cfg \
    file://features.cfg \
"

do_install:append() {
    ## QA Issue: File /boot/config-... in package kernel-dev contains reference to TMPDIR [buildpaths]
    sed -i 's!^\(CONFIG_EXTRA_FIRMWARE_DIR="\)${STAGING_DIR_TARGET}\(${nonarch_base_libdir}/firmware"\)!\1\2!' ${D}/boot/config-*
}

kernel_generate_dynamic_cfg:append() {
    printf 'CONFIG_EXTRA_FIRMWARE_DIR="%s"\n' '${STAGING_DIR_TARGET}${nonarch_base_libdir}/firmware' >> ${CFG_DYNAMIC}
}

## remove dependency on kernel-image; we do not ship it in the final
## rootfs
RRECOMMENDS:${KERNEL_PACKAGE_NAME}-base = ""

_ANY_FEATURES = "${MACHINE_FEATURES} ${DISTRO_FEATURES}"

## This function is run in two stages; in first one (what == False),
## it optimizes away unused features which might be reenabled by CPU
## or HW configuration.  In the second stage it enables corresponding
## features.
def _expand_yes_no(d, what):
    features = d.getVar('_YES_NO_FEATURES', True).split()
    avail    = set(d.getVar('_ANY_FEATURES', True).split())
    res = []
    for f in features:
        ## recognize extra files specified as '<feature>/<suffix>'
        tmp = f.split('/') + [None]
        f = tmp[0]

        if tmp[1] is not None:
            xtra = "_" + tmp[1]
        else:
            xtra = ""

        if what:
            yes = 'file://_%s%s-yes.cfg' % (f, xtra)
            no  = ''
        else:
            yes = ''
            no  = 'file://_%s-no.cfg' % f
        res.append([no, yes][f in avail])

    return ' '.join(res)
