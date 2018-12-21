{ pkgs, ... }:

let
  lib      = pkgs.stdenv.lib;
  homeDir  = builtins.getEnv "HOME";
  emacsDir = "${homeDir}/.emacs.d";
  doomDir  = "${emacsDir}";
  repoName = "machine-conf";
  repoPath = "${homeDir}/${repoName}";
in rec {
  imports = [
    ../common/home.nix
  ];

  programs = {
     home-manager = {
       enable = true;
       path = "../home-manager";
     };
  };

  home = {
    file = {
      ".nixpkgs/config.nix".source = "${repoPath}/config.nix";
      ".bashrc".source = "${repoPath}/bashrc";
      ".zshrc".source = "${repoPath}/zshrc";
      ".shrc".source = "${repoPath}/shrc";
      ".profile".source = "${repoPath}/profile";
      ".bash_profile".source = "${repoPath}/bash_profile";
      ".zprofile".source = "${repoPath}/zprofile";
      ".tmux.conf".source = "${repoPath}/tmux.conf";
      ".xprofile".source = "${repoPath}/xprofile";
      ".xsession".source = "${repoPath}/xsession";
      ".Xresources".source = "${repoPath}/Xresources";
      ".gnupg/gpg-agent.conf".source = "${repoPath}/gnupg/gpg-agent.conf";
      ".gnupg/gpg.conf".source = "${repoPath}/gnupg/gpg.conf";
    };
  };

  xdg = {
    enable = true;

    configFile = {
      "mpv/mpv.conf".source = "${repoPath}/config/mpv/mpv-station.conf";
      "mpv/scripts/dev/select-ao.lua".source = "${repoPath}/config/mpv/scripts/dev/select-ao.lua";
      "direnv/direnvrc".source = "${repoPath}/example-nix/tools/direnv/direnvrc";
      "doom".source = "${repoPath}/config/doom";
    };

    dataFile = {
      "qutebrowser/userscripts/org_capture".source = "${repoPath}/share/qutebrowser/userscripts/org_capture";
      "qutebrowser/userscripts/yank_org_link".source = "${repoPath}/share/qutebrowser/userscripts/yank_org_link";
      "zsh/site-functions/prompt_pure_setup".source = "${repoPath}/pure/pure.zsh";
      "zsh/site-functions/async".source = "${repoPath}/pure/async.zsh";
    };
  };
}
