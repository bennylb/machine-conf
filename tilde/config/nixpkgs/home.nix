{ pkgs, ... }:

let

  lib          = pkgs.stdenv.lib;

  homeDir      = builtins.getEnv "HOME";
  repoName     = "machine-conf";
  repoPrefix   = "${homeDir}/${repoName}/tilde";
  homePrefix   = "${homeDir}";
  interfixPath = "config";

  srcPaths = with lib; with builtins;
    { rpfix, hpfix, infix }:
      mapAttrsToList
        (n: v: if (v == "directory") then
                 srcPaths {
                   rpfix = rpfix;
                   hpfix = hpfix;
                   infix = (infix + "/${n}");
                 }
               else if (v == "regular") then {
                 name = toString ("${hpfix}/." + infix + "/${n}");
                 value = {
                   source = toPath ("${rpfix}/" + infix + "/${n}");
                 };
               } else [])
          (readDir ("${rpfix}/" + infix));

in rec {

  nixpkgs = {
    overlays =
      let path = ./overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));
  };

  programs = {
    home-manager = {
      enable = true;
      path   = https://github.com/rycee/home-manager/archive/master.tar.gz;
    };

    feh.enable = true;
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

  services = {
    gnome-keyring.enable = true;
    network-manager-applet.enable = true;
  };

  home = {
    # file = with builtins;
    #   listToAttrs
    #     (concatLists
    #       (srcPaths {
    #         rpfix = repoPrefix;
    #         hpfix = homePrefix;
    #         infix = interfixPath;}));

    # packages = [];
  };

  xdg = {
    enable = true;

    # configHome = "${homeDir}/.config";
    # cacheHome  = "${homeDir}/.cache";
    # dataHome   = "${homeDir}/.local/share";

    configFile."alacritty/alacritty.yml".source = "${repoPrefix}/config/alacritty/alacritty.yml";
    configFile."clipster/clipster.ini".source = "${repoPrefix}/config/clipster/clipster.ini";
    configFile."i3/config".source = "${repoPrefix}/config/i3/config";
    configFile."i3/pystatus.py".source = "${repoPrefix}/config/i3/pystatus.py";
    configFile."mpv/mpv.conf".source = "${repoPrefix}/config/mpv/mpv.conf";
    configFile."mpv/scripts/dev/select-ao.lua".source = "${repoPrefix}/config/mpv/scripts/dev/select-ao.lua";
    configFile."qutebrowser/bookmarks/urls".source = "${repoPrefix}/config/qutebrowser/bookmarks/urls";
    configFile."qutebrowser/config.py".source = "${repoPrefix}/config/qutebrowser/config.py";
    configFile."qutebrowser/default.nix".source = "${repoPrefix}/config/qutebrowser/default.nix";
    configFile."qutebrowser/quickmarks".source = "${repoPrefix}/config/qutebrowser/quickmarks";
    configFile."qutebrowser/requirements.nix".source = "${repoPrefix}/config/qutebrowser/requirements.nix";
    configFile."nixpkgs/overlays" = {
      source = "${repoPrefix}/config/nixpkgs/overlays";
      recursive = true;
    };
    configFile."direnv/direnvrc".source = "${repoPrefix}/example-nix/tools/direnv/direnvrc";
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
