
inherit phygittag
inherit buildinfo
include linux-common.inc

INTREE_DEFCONFIG = "imx6ull_consolinno_basemodule_defconfig"

COMPATIBLE_MACHINE  = "^("
COMPATIBLE_MACHINE .= "|consolinno-leaflet-1u0022-1"
COMPATIBLE_MACHINE .= ")$"

SRC_URI = "git://github.com/ConsolinnoEnergy/linux-mainline-phytec.git;branch=v5.4.y-phy-1u0022"
SRCREV 	= "5850686e12c9b705aa4389221b32e7b8f573427d"