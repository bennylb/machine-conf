#!/usr/bin/env sh

EC_BIN=/run/current-system/sw/bin/emacsclient

if [ -z "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

exec "$EC_BIN" "$@"
