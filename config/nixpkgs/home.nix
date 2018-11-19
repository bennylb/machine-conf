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

    file.".zshrc".source = "${repoRoot}/zshrc";
    file.".commonrc.sh".source = "${repoRoot}/commonrc.sh";
    file.".profile".source = "${repoRoot}/profile";
    file.".bash_profile".source = "${repoRoot}/bash_profile";
    file.".zprofile".source = "${repoRoot}/zprofile";
    file.".tmux.conf".source = "${repoRoot}/tmux.conf";
    file.".xsession".source = "${repoRoot}/xsession";
    file.".Xresources".source = "${repoRoot}/Xresources";
    file.".fehbg".source = "${repoRoot}/fehbg";
    file."bin/emc".source = "${repoRoot}/bin/emc.sh";
    file."bin/emd".source = "${repoRoot}/bin/emd.sh";
    file."bin/emw".source = "${repoRoot}/bin/emw.sh";
    file."bin/emc-wrap".source = "${repoRoot}/bin/emc-wrap.sh";
    file."bin/restart-emacs".source = "${repoRoot}/bin/restart-emacs.sh";
    file."bin/touchpad".source = "${repoRoot}/bin/touchpad.sh";
    file."bin/qutebrowser".source = "${repoRoot}/bin/qutebrowser.sh";

    # packages = [];
  };

  xdg = {
    enable = true;

    configFile."alacritty/alacritty.yml".source = "${repoRoot}/config/alacritty/alacritty.yml";
    configFile."clipster/clipster.ini".source = "${repoRoot}/config/clipster/clipster.ini";
    configFile."i3/config".source = "${repoRoot}/config/i3/config";
    configFile."i3/pystatus.py".source = "${repoRoot}/config/i3/pystatus.py";
    configFile."mpv/mpv.conf".source = "${repoRoot}/config/mpv/mpv.conf";
    configFile."mpv/scripts/dev/select-ao.lua".source = "${repoRoot}/config/mpv/scripts/dev/select-ao.lua";
    configFile."qutebrowser/bookmarks/urls".source = "${repoRoot}/config/qutebrowser/bookmarks/urls";
    configFile."qutebrowser/config.py".source = "${repoRoot}/config/qutebrowser/config.py";
    configFile."qutebrowser/quickmarks".source = "${repoRoot}/config/qutebrowser/quickmarks";
    configFile."direnv/direnvrc".source = "${repoRoot}/example-nix/tools/direnv/direnvrc";
    configFile."doom" = {
      source = "${repoRoot}/config/doom";
      recursive = true;
    };
    configFile."nixpkgs/overlays" = {
      source = "${repoRoot}/config/nixpkgs/overlays";
      recursive = true;
    };

    dataFile."qutebrowser/userscripts/org_capture".source = "${repoRoot}/share/qutebrowser/userscripts/org_capture";
    dataFile."qutebrowser/userscripts/yank_org_link".source = "${repoRoot}/share/qutebrowser/userscripts/yank_org_link";
    dataFile."zsh/site-functions/prompt_pure_setup".source = "${repoRoot}/pure/pure.zsh";
    dataFile."zsh/site-functions/async".source = "${repoRoot}/pure/async.zsh";
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
