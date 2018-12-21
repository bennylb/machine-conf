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
    feh.enable = true;
  };

  services = {
    network-manager-applet.enable = true;
  };

  home = {
    file = {
      ".fehbg".source = "${repoPath}/fehbg";
    };
  };

  xdg = {
    enable = true;

    configFile = {
      "clipster/clipster.ini".source = "${repoPath}/config/clipster/clipster.ini";
      "i3/config".source = "${repoPath}/config/i3/config";
      "i3/pystatus.py".source = "${repoPath}/config/i3/pystatus.py";
      "i3/rsstatus.toml".source = "${repoPath}/config/i3/rsstatus.toml";
      "mpv/mpv.conf".source = "${repoPath}/config/mpv/mpv-sputnik.conf";
      "qutebrowser/bookmarks/urls".source = "${repoPath}/config/qutebrowser/bookmarks/urls";
      "qutebrowser/config.py".source = "${repoPath}/config/qutebrowser/config.py";
      "qutebrowser/quickmarks".source = "${repoPath}/config/qutebrowser/quickmarks";
    };

    dataFile = {
      "qutebrowser/userscripts/org_capture".source = "${repoPath}/share/qutebrowser/userscripts/org_capture";
      "qutebrowser/userscripts/yank_org_link".source = "${repoPath}/share/qutebrowser/userscripts/yank_org_link";
    };
  };

  gtk = {
    enable         = true;
    font.name      = "Ubuntu 11";
    theme.name     = "Adwaita";
    iconTheme.name = "Adwaita";
    gtk2 = {
      extraConfig =
        ''
          gtk-enable-mnemonics = 0
          gtk-key-theme-name = "Emacs"
        '';
    };
    gtk3 = {
      extraConfig = {
        gtk-enable-mnemonics = 0;
        gtk-key-theme-name = "Emacs";
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };

  qt = {
    enable = true;
    useGtkTheme = true;
  };

}
