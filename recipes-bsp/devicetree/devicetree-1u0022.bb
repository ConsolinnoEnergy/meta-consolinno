FILESEXTRAPATHS:prepend := "${THISDIR}/dtree:"

SRC_URI = "\
    ${MACHINE_DTB_SOURCES} \
"

MACHINE_DTB_SOURCES[vardeps] += "MACHINE_DTBS"
MACHINE_DTB_SOURCES = "${@machine_dtbs_to_src_uri(d.getVar('MACHINE_DTBS'))}"

COMPATIBLE_MACHINE  = "consolinno-leaflet-1u0022-1"

DEFAULT_DTB ??= "${@d.getVar('MACHINE_DTBS').split()[0]}"

## Primary devicetree must export symbols too...
#DTC_BFLAGS:append = " -@"

inherit devicetree

def machine_dtbs_to_src_uri(dtbs):
    res = []
    for d in sorted((dtbs or "").split()):
        if d[-4:] == '.dtb':
            f = d[:-4]
        elif d[-5:] == '.dtbo':
            f = d[:-5]
        else:
            raise Exception("unsupported dtb name '%s'" % d)

        res.append('file://%s.dts' % f)

    return ' '.join(res)

pkg_postinst:${PN}() {
    ln -sf devicetree/'${DEFAULT_DTB}' $D/boot/oftree.dtb
}
