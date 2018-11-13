#!/usr/bin/env sh

ES_SOCK="/tmp/emacs1000/server"
EC_BIN="/home/ben/bin/emc-wrap"

$EC_BIN -c -a "" --socket-name=$ES_SOCK "$@"
