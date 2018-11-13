#!/usr/bin/env sh

ed_sock="/tmp/emacs1000/server"
ed_path="/run/current-system/sw/bin/emacs"

$ed_path --daemon=$ed_sock

