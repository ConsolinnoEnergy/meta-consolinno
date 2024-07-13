require ${THISDIR}/barebox-1u0022.inc

PATCHSET += "\
    file://0000-generic.patch \
    file://0001-imx-do-not-apply-errata-845369-for-single-core.patch \
"

COMPATIBLE_MACHINE = "consolinno-leaflet-1u0022-1"
