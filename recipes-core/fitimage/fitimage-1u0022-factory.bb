require fitimage-1u0022.inc

FITIMAGE_BOOT_NAME = "factory"

FITIMAGE_RAMDISKS = "${DEPLOY_DIR_IMAGE}/1u0022-initrd-factory-${MACHINE}.cpio.gz"

FITIMAGE_COMPONENTS += "virtual/initrd-factory:do_image_complete"

RPROVIDES:${PN}-image = "virtual/fitimage-factory"
PROVIDES += "virtual/fitimage-factory"
