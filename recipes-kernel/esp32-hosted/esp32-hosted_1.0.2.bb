SUMMARY = "ESP-Hosted solution provides a way to use ESP board as a communication processor i.e. host for Wi-Fi and Bluetooth/BLE connectivity"
HOMEPAGE = "https://github.com/espressif/esp-hosted/"
LICENSE = "GPL-2.0-or-later"
#LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e6a75371ba4d16749254a51215d13f97"

SRC_URI = "gitsm://github.com/espressif/esp-hosted.git;branch=master;protocol=https"

#SRCREV = "release/v${PV}"
#SRCREV = "release/ng-v${PV}"
SRCREV = "29208b6c156be06dfd90dadc6dd43acd4d98d748"

S = "${WORKDIR}/git/esp_hosted_ng/host"

inherit module

EXTRA_OEMAKE:append:task-install = " -C ${STAGING_KERNEL_DIR} M=${S}"

EXTRA_OEMAKE += "\
    target=sdio \
    CROSS_COMPILE='${TARGET_PREFIX}' \
    KERNEL=${STAGING_KERNEL_DIR} \
    -j${BB_NUMBER_THREADS} \
"

RPROVIDES_${PN} += "kernel-module-esp-hosted"
