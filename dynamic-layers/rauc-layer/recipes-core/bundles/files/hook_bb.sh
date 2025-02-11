#! /bin/bash

set -e
set -x


eMMC_device=/dev/mmcblk1

_get_active_bootpart() {
  local partnum=$(/usr/bin/mmc extcsd read /dev/mmcblk1 |/usr/bin/grep -E 'Boot Partition.*enabled'|sed -e 's/^\(.*Boot\ Partition\ \)\([1,2]\)\ enabled/\2/g')
  #fallback 1
  test -z "$partnum" && partnum=1
  echo $partnum
}


_install_bootloader() {
    local image="$1"
    local idx="$2"
    local dev=${eMMC_device}boot${idx}

    local sysfs=/sys/class/block/${dev##*/}
    echo "installing bootloader to $dev ..."
    echo 0 > "$sysfs"/force_ro
    dd if="$image" of="$dev" bs=512 conv=fsync; rc=$?
    echo 1 > "$sysfs"/force_ro
    return $rc
}

_is_installed_bootloader() {
    local image="$1"
    local idx="$2"
    local TMPIMAGE=$(mktemp)
    local dev=${eMMC_device}boot${idx} 

    dd if=${dev} of="${TMPIMAGE}" bs=512 count=$(($(stat --format="%s" ${image}) / 512))

    cmp -s ${image} ${TMPIMAGE}; ret=$?
    rm ${TMPIMAGE}
    
    echo -n "verifying bootloader $dev ... "
    if [ $ret -eq 0 ]; then
      echo " ok"
    else
      echo " differs!"
    fi

    return $ret
}

RAUC_BUNDLE_MOUNT_PATH=$(realpath $(dirname $0))

# this should be a secure method to update the barebox bootloader in field:
# security is ensured by:
# 1. no unnecessary write attempts, first binary compare the active bootloader with the update file
# 2. always write the update file to the inactive emmc boot[0/1] Partition, never touch the active partition
# 3. after successfully written switch the enabled bootpartition by an atomic operation
update_bootloader() {
    local image
    image="$(ls ${RAUC_BUNDLE_MOUNT_PATH}/barebox*.img)"
	  [ -f "$image" ] || { echo "error: no barebox image found"; return 1; }
    local inactive=0
    local active=$(($(_get_active_bootpart) - 1))
    if [ $active -eq 1 ]; then
      inactive=0
    else 
      inactive=1
    fi
    if ! _is_installed_bootloader "${image}" ${active} ; then 
      echo "installing to inactive boot${inactive} partition ..."
      _install_bootloader "${image}" ${inactive}
      rc=$?
      if [ $rc -eq 0 ]; then
        echo "switch bootpartition by /usr/bin/mmc bootpart enable $(($inactive + 1)) 0 ${eMMC_device}"
        /usr/bin/mmc bootpart enable $(($inactive + 1)) 0 ${eMMC_device}
      else
        echo "error writing inactive boot partition"
      fi 
    fi
}

echo "$0 $1:$RAUC_SLOT_CLASS"
case "$1:$RAUC_SLOT_CLASS" in
  install-check:)
	  # sanity check; factory init creates these files
	  test -e /boot/system-A.fit
	  test -e /boot/system-B.fit
    #install-check is the single bundle-hook, so here is the place to update bootloader 
    #as long as system.conf lacks a bootloader slot
    update_bootloader # || true
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
  slot-pre-install:bootloader)
    ;;
  slot-post-install:bootloader)
    #method with defined slot 'bootloader' in system.conf
    #update_bootloader
    ;;
esac
