================
mdev like a boss
================

This repo is a stash for notes, scripts and configs for the system running with mdev as a udev replacement.

Quickstart
==========
Gentoo-based system as example.

- Clone repo as root to /opt/mdev::

        git clone https://github.com/slashbeast/mdev-like-a-boss.git /opt/mdev

- Build sys-apps/busybox with 'mdev' use flag.

- Copy ``/opt/mdev/mdev.init`` to ``/etc/init.d/mdev``, replace the original one if exist, add exec bit ad add to sysinit runlevel::
        
        cp /opt/mdev/mdev.init /etc/init.d/mdev
        chmod 700 /etc/init.d/mdev
        rc-update add mdev sysinit

- Remove udev from sysinit runlevel (it can be udev or udevd, depends if Gentoo or Funtoo)::

        rc-update del udev sysinit

- Now go to /etc/init.d/ and copy ``/opt/mdev/hwcoldplug.init`` to ``hwcoldplug``. Add exec bit and add it into boot runlevel::

        cp /opt/mdev/hwcoldplug.init /etc/init.d/hwcoldplug
        chmod +x /etc/init.d/hwcoldplug
        rc-update add hwcoldplug boot

- Copy or symlink ``/opt/mdev/mdev.conf`` to ``/etc/mdev.conf``::

        ln -sf /opt/mdev/mdev.conf /etc/mdev.conf

- Now you can reboot, mdev should be up and running.

Xorg
====
Build xorg-server with '-udev' USEFLAG. As we no longer use udev, we can't use evdev. Install mouse and keyboard drivers, and if you use touchpad synaptics as well. 
The input configuration is not the same as with evdev, we will no longer use 'InputClass' but 'InputDevice' sections. You propably do not need ``xorg.conf`` at all. Create ``/etc/X11/xorg.conf.d/`` and copy content of the ``/opt/mdev/xorg.conf.d/`` there. Then adjust the config files as you wish.

Keymaps
=======
One of udev's features is config keymaps when it detect specified vendor. Mdev does not do so, mdev is for /dev, not for all-other-things. In order to make your special keys working you need to assign keycode to them. You can generate proper setkeycodes commands from udev's sources with ``get-keys.awk`` script. like::

        awk -f keymaps/get-keys.awk /usr/include/linux/input.h /PATH/TO/UDEV/SOURCE/DIR/src/keymap/keymaps/NAME

To make life easier, ``keymap`` dir contain already generated scripts from udev-182's keymaps files. All what you need is to put ``/opt/mdev/keymaps/NAME.sh`` into one of your startup scripts.

Preserve interfaces names
=========================
Mdev does not provide bulitin support for renaming NICs. However there is ``settle-nics`` script which will do it using nameif (can be from net-tools or busybox) and ip (can be original iproute2 or busybox's iproute2 implementation). The settle-nics script create /etc/mactab file with detected eth*, wlan*, ath*, wifi*, ra* and usb* interfaces. Any other is ignored, you need to edit this file by hand if you wish add other names.

Random notes
============
- Keycodes under Xorg may be different than with evdev, for example mute keycode is no longer 121 but 160. Install 'xev' and check your keycodes if you remap or bind them with xmodmap.
- Mdev does not auto-load modules for your hardware. Thats why ``hwcoldplug`` initscript exist.
- Mdev does not support udev's udisks and so on, Full blown desktop environments may not really like the change, you will lost your DE's automount stuff etc. But there is ``pmount`` and you can always config automount script in ``/etc/mdev.conf``
- Mdev does not create by default /dev/disk/by-* etc. If you want such fancy stuff, check devicemapper.sh script which is executed on dm-[0-9]+ create.
- ``mdev.init`` is a default mdev init script from gentoo, added for reference.
- Unmerging udev may not be good idea, as for example chromium need libudev to compile. Better append ``sys-fs/udev -*`` to package.use and put ``sys-fs/udev-init-scripts-10`` into ``/etc/portage/profile/package.provided``. Then you can rebuild udev with all USE flags disabled and remove udev-init-scripts.
