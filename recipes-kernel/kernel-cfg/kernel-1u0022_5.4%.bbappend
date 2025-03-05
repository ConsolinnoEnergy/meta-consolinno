COMPATIBLE_MACHINE  = "consolinno-leaflet-1u0022-1"

KCONFIG_DEFCONFIG:consolinno-leaflet-1u0022-1 = "${S}/arch/arm/configs/imx6ull_consolinno_basemodule_defconfig"

CFGSET = "\
    ${_CFGSET_COMMON} \
"

PATCHSET = "\
    file://0000-generic.patch \
    file://conegx-driver-v1-2-0.patch \
"
