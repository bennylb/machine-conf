#!/usr/bin/env sh

es_sock="/tmp/emacs1000/server"
ec_path="/run/current-system/sw/bin/emacsclient"

$ec_path -c -a "" --socket-name=$es_sock "$@"
