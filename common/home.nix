{ pkgs, ... }:

let
  lib = pkgs.stdenv.lib;
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
      ".aliases".source = "${repoPath}/aliases";
    };
  };
  
}
