#!/bin/bash

#
# This script processes a Linux .config file to look for options that
# are desirable for Nerves. Run it by calling:
#
#     ./lint-kernel.sh mylinuxkernel/.config
#
# While it does work with defconfigs, if you get a warning, it may be
# the case that the configuration option in question has been omitted
# from the file. When in doubt run against the .config file which has
# all of the options listed.
#

set -e

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <.config>"
    exit 1
fi

warnings=0

checks=( "CONFIG_INPUT_EVDEV" "GUIs and tools that use the Linux input system won't work." \
         "CONFIG_VT_HW_CONSOLE_BINDING" "screen and dtach won't work." \
         "CONFIG_SQUASHFS" "The root filesystem won't mount." \
         "CONFIG_IP_ADVANCED_ROUTER" "Routing between network interfaces won't work." \
         "CONFIG_NETFILTER" "iptables won't work." \
         )
lint() {
    filename=$1

    count=${#checks[@]}
    index=0
    while [ "$index" -lt "$count" ]; do
        str=${checks[$index]}
        if ! grep "$str=y" $filename >/dev/null; then
            err=${checks[(($index + 1))]}
            echo "$filename: $str not enabled. $err"
            ((warnings++)) || true
        fi
        ((index=$index+2))
    done
}

for file in $@; do
    lint $file
done

echo "Found $warnings possible issues."

