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
      "mpv/mpv.conf".source = "${repoPath}/config/mpv/mpv-station.conf";
      "streamlink/config".source = "${repoPath}/config/streamlink/config";
    };

    dataFile = {

    };
  };
}
