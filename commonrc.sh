# Shell agnostic configuration to be sourced from your shell rc.

# TMUX
if which tmux >/dev/null 2>&1; then
    case "$TERM" in
        linux | eterm-color | xterm-kitty)
            true
            ;;
        *)
            test -z "$TMUX" && (tmux attach || tmux new-session)
            ;;
    esac
fi

# if not on nixos
OS_ID=`sed -n 's/^ID=//p' /etc/os-release`

# if [[ "$OS_ID" != "nixos" ]]; then
# For the time being ssh auth sock will need to be set here as the nixos
# module enabling the support is problematic.
if [[ true ]]; then
    # Use gpg-agent as ssh-agent
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null

    unset SSH_AGENT_PID
    # if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    #     export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    # fi
    if [ -z "$SSH_AUTH_SOCK" ]; then
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    fi
fi


# Aliases
alias sudo="sudo "
# alias less="less -R"
alias fd="fd"
alias du="du -h"
# systemctl
alias sd="systemctl"
alias sdu="systemctl --user"
# Run nix repl and load nixos config
alias nxrc="nix repl '<nixpkgs/nixos>'"
# Run nix repl and load nixos lib
alias nxrl="nix repl '<nixos/lib>'"
alias nxcatpkg="EDITOR=bat nix edit"
# Erase clipster's history
alias clpdh="clipster -c --erase-entire-board"
alias shrld="exec $SHELL -l"
alias saleor="make -f dev-example.Makefile"

# Use function to create the respective alias as completion fails
# when using a plain alias.
cat() { command bat --style=plain "$@" }
less() { command bat --style=plain "$@" }


# Functions
# Source https://github.com/direnv/direnv/wiki/Nix
nixify() {
    if [ ! -e ./.envrc ]; then
        cat > .envrc <<'EOF'
use_nix_gcrooted -c

# Set addtional variables here
#
# e.g
#
# Adds virtualenv bin to PATH
# PATH_add ./venv/bin
#
# Adds node_modules/.bin to PATH
# layout_node
#
# path_add VAR ./path/to/lib/or/bin
# e.g add libs to PYTHONPATH
# path_add PYTHONPATH ./path/to/some/lib
#
# For more information see: man direnv-stdlib
EOF
        # direnv allow
    fi
}

nixify_create() {
    nixify

    if [ ! -e shell.nix ]; then
        cat > shell.nix <<'EOF'
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  # inputsFrom = [
  #
  # ];
  buildInputs = with pkgs; [
    bashInteractive
  ];
}
EOF
        $EDITOR shell.nix
    fi
}
