#!/bin/sh
# Copyright (c) 2012, Piotr Karbowski <piotr.karbowski@gmail.com>

# This script intend to create proper /dev/mapper/ symlinks to /dev/dm-* devices.

### debug
#exec >> /run/debug-mdev 2>&1
#set -x
#echo '### ENV:'
#env
#echo '### CODE:'

if [ -z "${MDEV}" ]; then exit 1; fi

case "$ACTION" in
	add|'')
		test -d /dev/mapper || mkdir /dev/mapper
		if ! test -c /dev/mapper/control; then
			dmminor="$(awk '$2 == "device-mapper" { print $1; exit; }' /proc/misc)"
			mknod '/dev/mapper/control' c 10 "${dmminor}"
		fi

		if [ -f "/sys/block/${MDEV}/dm/name" ]; then
			_name="$(cat /sys/block/${MDEV}/dm/name)"
			ln -sf "/dev/${MDEV}" "/dev/mapper/${_name}"
		fi
esac
