{ pkgs, ... }:

let
  lib      = pkgs.stdenv.lib;
  homeDir  = builtins.getEnv "HOME";
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

    };
  };

  xdg = {
    enable = true;

    configFile = {

    };

    dataFile = {

    };
  };
}
