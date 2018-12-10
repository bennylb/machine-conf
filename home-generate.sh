#!/usr/bin/env sh

XDG_NIX_PKGS="$HOME"/.config/nixpkgs

if ! which home-manager; then
    if ! test -d "$XDG_NIX_PKGS"; then
        mkdir -p "$XDG_NIX_PKGS"
        ln -s ./config/nixpkgs/home.nix "$XDG_NIX_PKGS"/home.nix
    fi
    nix-shell ./home-manager -A install
else
    printf '%s \n' "home-manager is already installed. "
    printf '%s' "If you have no already done so, run "
    printf '%s \n' "home-manager swtich to create you first generation."
fi
