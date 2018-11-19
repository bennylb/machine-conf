#
# ~/.bash_profile
#

# Contents of ~/.bash_profile will only be read when starting
# a login shell (when logging in to your window manager).

# For anything that needs to be loaded each time a new terminal
# (non-login shell) is started place it ~/.bashrc.
#
# For example vi mode nees to be loaded evertime a terminal is
# opened so set -o vi needs to placed in ~/.bashrc.

. ~/.profile
case $- in *i*) . ~/.bashrc;; esac
