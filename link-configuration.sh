#!/usr/bin/env sh

NIX_CONF=/etc/nixos/configuration.nix

if [ "$EUID" -eq 0 ]; then
    if test -e "$NIX_CONF"; then
        cp "$NIX_CONF" "$NIX_CONF".bak
        rm -f /etc/nixos/configuration.nix
    fi
    ln -s ./sputnik.nix "$NIX_CONF"
else
    echo "Must be run as root."
    exit 1
fi
