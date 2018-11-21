# -*- mode: sh; eval: (sh-set-shell "bash"); -*-
# Contents of ~/.bash_profile will only be read when starting
# a login shell (when logging in to your window manager).
#
# For anything that needs to be available each time a new 
# terminal (non-login shell) is started place it in ~/.bashrc.

. ~/.profile

case $- in *i*) . ~/.bashrc;; esac
