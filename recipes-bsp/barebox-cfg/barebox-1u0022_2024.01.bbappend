python () {
    if d.getVar('DISTRO_VARIANT_CODE') == 'CO':
        bb.build.exec_func('require', d, "${THISDIR}/barebox-1u0022.inc")
        d.appendVar('PATCHSET', "\
            file://0000-generic.patch \
            file://0001-imx-do-not-apply-errata-845369-for-single-core.patch \
        ")
        d.setVar('COMPATIBLE_MACHINE', "consolinno-leaflet-1u0022-1")
    #else:
        #bb.note("Skipping append script because DISTRO_VARIANT_CODE is not 'CO'")
}
