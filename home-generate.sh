#!/usr/bin/env sh

XDG_NIX_PKGS="$HOME"/.config/nixpkgs

if ! which home-manager; then
    if ! test -d "$XDG_NIX_PKGS"; then
        mkdir -p "$XDG_NIX_PKGS"
        ln -s ./config/nixpkgs/home.nix "$XDG_NIX_PKGS"/home.nix
    fi
    nix-shell ./home-manager -A install
else
    printf '\n%s\n%s %s\n' \
        "home-manager is already installed." \
        "If you have no already done so, run" \
        "home-manager swtich to create you first generation."
fi
