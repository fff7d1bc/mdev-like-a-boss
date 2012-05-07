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

- Add mdev into sysinit runlevel::

        rc-update add mdev sysinit

- Remove udev from sysinit runlevel (it can be udev or udevd, depends if Gentoo or Funtoo)::

        rc-update del udev sysinit

- Now go to /etc/init.d/ and copy ``/opt/mdev/hwmodules.init`` to ``hwmodules``. Add exec bit and add it into boot runlevel::

        cp /opt/mdev/hwmodules.init /etc/init.d/hwmodules
        chmod +x /etc/init.d/hwmodules
        rc-update add hwmodules boot

- Now you can reboot, mdev should be up and running.

Xorg
====
Build xorg-server with '-udev' USEFLAG. As we no longer use udev, we can't use evdev. Install mouse and keyboard drivers, and if you use touchpad synaptics as well. 
The input configuration is not the same as with evdev, we will no longer use 'InputClass' but 'InputDevice' sections. You propably do not need ``xorg.conf`` at all. Create ``/etc/X11/xorg.conf.d/`` and copy content of the ``/opt/mdev/xorg.conf.d/`` there. Then adjust the config files as you wish.

Notes
=====

- Keycodes under Xorg may be different than with evdev, for example mute keycode is no longer 121 but 160. Install 'xev' and check your keycodes if you remap or bind them with xmodmap.
- Mdev does not rename interfaces. If you rely on them, you may want to use ``ifrename`` from ``wireless-tools``.
- Mdev does not auto-load modules for your hardware. Thats why ``hwmodules`` initscript exist.
- Mdev does not support udev's udisks and so on, Full blown desktop environments may not really like the change, you will lost your DE's automount stuff etc. But there is ``pmount`` and you can always config automount script in ``/etc/mdev.conf``
- Mdev does not create by default /dev/disk/by-* etc. If you want such fancy stuff, check devicemapper.sh script which is executed on dm-[0-9]+ create.
- ``mdev.init`` is a default mdev init script from gentoo, added for reference.
