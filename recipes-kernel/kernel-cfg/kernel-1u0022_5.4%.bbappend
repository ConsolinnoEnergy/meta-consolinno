COMPATIBLE_MACHINE  = "consolinno-leaflet-1u0022-1"

KCONFIG_DEFCONFIG:consolinno-leaflet-1u0022-1 = "${S}/arch/arm/configs/imx6ull_consolinno_basemodule_defconfig"

CFGSET = "\
    ${_CFGSET_COMMON} \
"

PATCHSET = "\
    file://0000-generic.patch \
"

GITHUB_REPO  = "https://github.com/ConsolinnoEnergy/linux-mainline-phytec"
FIRST_COMMIT = "d0309316eb43ce2b0b882a8e91e563fe898df6ce" # first commit after generic patch
LAST_COMMIT  = "ca900c916cb8b1d619800d79619c8893fd9422a9" # gpio conegx: bump driver version to 1.4.1

SRC_URI += "${GITHUB_REPO}/compare/${FIRST_COMMIT}...${LAST_COMMIT}.patch;apply=yes;name=conegx_driver_patch"