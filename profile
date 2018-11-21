# -*- mode: sh; eval: (sh-set-shell "bash"); -*-
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
# umask 022
#
# Contents of ~/.profile will only be read when starting
# a login shell (when logging in to your window manager).

# For anything that needs to be loaded each time a new terminal
# (non-login shell) is started place it ~/.bashrc.
#
# For example vi mode nees to be loaded evertime a terminal is
# opened so set -o vi needs to placed in ~/.bashrc.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	      . "$HOME/.bashrc"
    fi
fi

# if not on nixos
# OS_ID=`sed -n 's/^ID=//p' /etc/os-release`
# if [[ "$OS_ID" != "nixos" ]]; then echo true; fi

# Use gpg-agent as ssh-agent
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

unset SSH_AGENT_PID
if [ -z "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

# Try and use Emacs client as default editor where possible
export ALTERNATE_EDITOR=''
export EDITOR='emacsclient -a ""'
export VISUAL='emacsclient -a ""'
