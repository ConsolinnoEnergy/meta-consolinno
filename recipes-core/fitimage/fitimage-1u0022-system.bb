require fitimage-1u0022.inc

FITIMAGE_BOOT_NAME = "system"

FITIMAGE_RAMDISKS = "${DEPLOY_DIR_IMAGE}/1u0022-initrd-system-${MACHINE}.cpio.gz"

FITIMAGE_COMPONENTS += "virtual/initrd-system:do_image_complete"

RPROVIDES:${PN}-image = "virtual/fitimage-system"
PROVIDES += "virtual/fitimage-system"
