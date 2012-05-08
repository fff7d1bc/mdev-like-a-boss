#!/usr/bin/awk -f
# Copyright (c) 2012, Piotr Karbowski <piotr.karbowski@gmail.com>

BEGIN { 
	if (!(ARGC==3)) {
		print "Wrong number of arguments" > "/dev/stderr";
		print "Usage: awk -f get-keys.awk /usr/include/linux/input.h /path/to/udev/sources/src/keymap/keymaps/dell" > "/dev/stderr";

		exit 1;
	}

	print "#!/bin/sh"
}


/^#define.*KEY_[^ ]+[ \t]+[0-9]/ { 
	if ($2 != "KEY_MAX") {
		sub("^KEY_", "", $2);
		$2=tolower($2);
		kern_keycodes[$2]=$3
	}
}

$1 ~ /^0x/ {
	# Strip first two fields and '# '.
	le_line=$0;
	sub(/^[[:blank:]]*([^[:blank:]]+[[:blank:]]+){2}# /,"", le_line)
	if (kern_keycodes[$2] != "") {
		print "setkeycodes", $1, kern_keycodes[$2], "#", le_line;
	}
}
