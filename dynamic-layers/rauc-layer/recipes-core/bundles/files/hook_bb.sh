#! /bin/sh

set -e
set -x


eMMC_device=/dev/mmcblk1

_install_bootloader() {
    local image="$1"
    local idx="$2"
    local dev=${eMMC_device}boot${idx}

    local sysfs=/sys/class/block/${eMMC_device##*/}

    echo 0 > "$sysfs"/force_ro
    dd if="$image" of="$dev" bs=512 conv=fsync; rc=$?
    echo 1 > "$sysfs"/force_ro
    return $rc
}

_is_installed_bootloader() {
    local image="$1"
    local idx="$2"
    local TMPIMAGE=$(mktemp)

    dd if=${eMMC_device}boot${idx} of="${TMPIMAGE}" bs=1 count=$(stat --format="%s" ${image})

    cmp -s ${image} ${TMPIMAGE}; ret=$?

    rm ${TMPIMAGE}
    return $ret
}

update_bootloader() {
    local image="$(ls ${RAUC_BUNDLE_MOUNT_PATH}/barebox*.img)"
	[ -f "$image" ] || return 1

    _is_installed_bootloader "${image}" 0 || _install_bootloader "${image}" 0 
    _is_installed_bootloader "${image}" 1 || _install_bootloader "${image}" 1 

	#switching enabled bootpart probably requires reconfiguration of imx6ull boot config, so better don't touch
    # mmc bootpart enable 1 0 ${eMMC_device}
    # mmc bootpart enable 2 0 ${eMMC_device}
}

case "$1:$RAUC_SLOT_CLASS" in
  install-check:)
	# sanity check; factory init creates these files
	test -e /boot/system-A.fit
	test -e /boot/system-B.fit
	update_bootloader 
	;;

  slot-pre-install:fitimage)
	# ensure that /boot is mounted (required for systemd automount)
	test -e /boot/.
	mount -o remount,rw $(dirname "$RAUC_SLOT_DEVICE")
	truncate -s "$RAUC_IMAGE_SIZE" "$RAUC_SLOT_DEVICE"
	;;

  slot-post-install:fitimage)
	mount -o remount,ro $(dirname "$RAUC_SLOT_DEVICE")
	;;
esac
