#! /bin/sh

set -e
set -x

case "$1:$RAUC_SLOT_CLASS" in
  install-check:)
	# sanity check; factory init creates these files
	test -e /boot/system-A.fit
	test -e /boot/system-B.fit
	;;

  slot-pre-install:fitimage)
	mount -o remount,rw $(dirname "$RAUC_SLOT_DEVICE")
	truncate -s "$RAUC_IMAGE_SIZE" "$RAUC_SLOT_DEVICE"
	;;
esac
