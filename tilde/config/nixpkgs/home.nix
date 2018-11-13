{ pkgs, ... }:

let

  lib          = pkgs.stdenv.lib;

  homeDir      = builtins.getEnv "HOME";
  interfixPath = "config";
  repoName     = "machine-conf";
  homePrefix   = "${homeDir}";
  repoRoot     = "${homeDir}/${repoName}";
  tilde        = "${homeDir}/${repoName}/tilde";

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
    #         rpfix = tilde;
    #         hpfix = homePrefix;
    #         infix = interfixPath;}));

    file.".commonrc.sh".source = "${repoRoot}/commonrc.sh";

    # packages = [];
  };

  xdg = {
    enable = true;

    # configHome = "${homeDir}/.config";
    # cacheHome  = "${homeDir}/.cache";
    # dataHome   = "${homeDir}/.local/share";

    configFile."alacritty/alacritty.yml".source = "${tilde}/config/alacritty/alacritty.yml";
    configFile."clipster/clipster.ini".source = "${tilde}/config/clipster/clipster.ini";
    configFile."i3/config".source = "${tilde}/config/i3/config";
    configFile."i3/pystatus.py".source = "${tilde}/config/i3/pystatus.py";
    configFile."mpv/mpv.conf".source = "${tilde}/config/mpv/mpv.conf";
    configFile."mpv/scripts/dev/select-ao.lua".source = "${tilde}/config/mpv/scripts/dev/select-ao.lua";
    configFile."qutebrowser/bookmarks/urls".source = "${tilde}/config/qutebrowser/bookmarks/urls";
    configFile."qutebrowser/config.py".source = "${tilde}/config/qutebrowser/config.py";
    configFile."qutebrowser/default.nix".source = "${tilde}/config/qutebrowser/default.nix";
    configFile."qutebrowser/quickmarks".source = "${tilde}/config/qutebrowser/quickmarks";
    configFile."qutebrowser/requirements.nix".source = "${tilde}/config/qutebrowser/requirements.nix";
    configFile."direnv/direnvrc".source = "${repoRoot}/example-nix/tools/direnv/direnvrc";
    configFile."doom" = {
      source = "${tilde}/config/doom";
      recursive = true;
    };
    configFile."nixpkgs/overlays" = {
      source = "${tilde}/config/nixpkgs/overlays";
      recursive = true;
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
