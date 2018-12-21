{ pkgs, ... }:

let
  lib      = pkgs.stdenv.lib;
  homeDir  = builtins.getEnv "HOME";
  repoName = "machine-conf";
  repoPath = "${homeDir}/${repoName}";
in {
  nixpkgs = {
    overlays =
      let path = ../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));
  };

  programs = {
    man.enable = true;

    git = {
      enable    = true;
      userName  = "Ben Backhouse";
      userEmail = "bennylb0@gmail.com";
      extraConfig = {
        github.user = "bennylb";
      };
    };
  };

  home = {
    file = {
      "bin".source = "${repoPath}/bin";
      ".nixpkgs/config.nix".source = "${repoPath}/config.nix";
      ".bashrc".source = "${repoPath}/bashrc";
      ".zshrc".source = "${repoPath}/zshrc";
      ".shrc".source = "${repoPath}/shrc";
      ".profile".source = "${repoPath}/profile";
      ".bash_profile".source = "${repoPath}/bash_profile";
      ".zprofile".source = "${repoPath}/zprofile";
      ".aliases".source = "${repoPath}/aliases";
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
      "mpv/scripts/dev/select-ao.lua".source = "${repoPath}/config/mpv/scripts/dev/select-ao.lua";
      "direnv/direnvrc".source = "${repoPath}/example-nix/tools/direnv/direnvrc";
      "doom".source = "${repoPath}/config/doom";
    };

    dataFile = {
      "zsh/site-functions/prompt_pure_setup".source = "${repoPath}/pure/pure.zsh";
      "zsh/site-functions/async".source = "${repoPath}/pure/async.zsh";
    };
  };
  
}
