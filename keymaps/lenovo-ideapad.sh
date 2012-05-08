#!/bin/sh
setkeycodes 0x81 247 # does nothing in BIOS
setkeycodes 0x83 245 # BIOS toggles screen state
setkeycodes 0xB9 225 # does nothing in BIOS
setkeycodes 0xBA 224 # does nothing in BIOS
setkeycodes 0xF1 212 # BIOS toggles camera power
setkeycodes 0xf2 191 # touchpad toggle (key alternately emits f2 and f3)
setkeycodes 0xf3 191 # 0xf3 f21
