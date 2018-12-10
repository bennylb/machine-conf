{ pkgs, ... }:

let

  lib          = pkgs.stdenv.lib;

  homeDir      = builtins.getEnv "HOME";
  interfixPath = "config";
  emacsDir     = "${homeDir}/.emacs.d";
  doomDir      = "${emacsDir}";
  repoName     = "machine-conf";
  repoRoot     = "${homeDir}/${repoName}";
  tilde        = "${homeDir}/${repoName}/tilde";

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
      path = "...";
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
    # gnome-keyring.enable = true;
    network-manager-applet.enable = true;
  };

  home = {

    file = {
      ".nixpkgs/config.nix".source = "${repoRoot}/config.nix";
      ".bashrc".source = "${repoRoot}/bashrc";
      ".zshrc".source = "${repoRoot}/zshrc";
      ".shrc".source = "${repoRoot}/shrc";
      ".profile".source = "${repoRoot}/profile";
      ".bash_profile".source = "${repoRoot}/bash_profile";
      ".zprofile".source = "${repoRoot}/zprofile";
      ".tmux.conf".source = "${repoRoot}/tmux.conf";
      ".xprofile".source = "${repoRoot}/xprofile";
      ".xsession".source = "${repoRoot}/xsession";
      ".Xresources".source = "${repoRoot}/Xresources";
      ".fehbg".source = "${repoRoot}/fehbg";
      ".gnupg/gpg-agent.conf".source = "${repoRoot}/gnupg/gpg-agent.conf";
      ".gnupg/gpg.conf".source = "${repoRoot}/gnupg/gpg.conf";
      "bin/emc".source = "${repoRoot}/bin/emc.sh";
      "bin/emd".source = "${repoRoot}/bin/emd.sh";
      "bin/emw".source = "${repoRoot}/bin/emw.sh";
      "bin/emc-wrap".source = "${repoRoot}/bin/emc-wrap.sh";
      "bin/restart-emacs".source = "${repoRoot}/bin/restart-emacs.sh";
      "bin/touchpad".source = "${repoRoot}/bin/touchpad.sh";
      "bin/qutebrowser".source = "${repoRoot}/bin/qutebrowser.sh";
      "bin/doom".source = "${doomDir}/bin/doom";
      "bin/doom-doctor".source = "${doomDir}/bin/doom-doctor";
      "bin/nixos-switch".source = "${repoRoot}/bin/nixos-switch.sh";
    };

    # packages = [];
  };

  xdg = {
    enable = true;

    configFile = {
      "alacritty/alacritty.yml".source = "${repoRoot}/config/alacritty/alacritty.yml";
      "clipster/clipster.ini".source = "${repoRoot}/config/clipster/clipster.ini";
      "i3/config".source = "${repoRoot}/config/i3/config";
      "i3/pystatus.py".source = "${repoRoot}/config/i3/pystatus.py";
      "i3/rsstatus.toml".source = "${repoRoot}/config/i3/rsstatus.toml";
      "mpv/mpv.conf".source = "${repoRoot}/config/mpv/mpv.conf";
      "mpv/scripts/dev/select-ao.lua".source = "${repoRoot}/config/mpv/scripts/dev/select-ao.lua";
      "qutebrowser/bookmarks/urls".source = "${repoRoot}/config/qutebrowser/bookmarks/urls";
      "qutebrowser/config.py".source = "${repoRoot}/config/qutebrowser/config.py";
      "qutebrowser/quickmarks".source = "${repoRoot}/config/qutebrowser/quickmarks";
      "direnv/direnvrc".source = "${repoRoot}/example-nix/tools/direnv/direnvrc";
      "doom" = {
        source = "${repoRoot}/config/doom";
        recursive = true;
      };
      "nixpkgs/overlays" = {
        source = "${repoRoot}/config/nixpkgs/overlays";
        recursive = true;
      };
    };

    dataFile = {
      "qutebrowser/userscripts/org_capture".source = "${repoRoot}/share/qutebrowser/userscripts/org_capture";
      "qutebrowser/userscripts/yank_org_link".source = "${repoRoot}/share/qutebrowser/userscripts/yank_org_link";
      "zsh/site-functions/prompt_pure_setup".source = "${repoRoot}/pure/pure.zsh";
      "zsh/site-functions/async".source = "${repoRoot}/pure/async.zsh";
    };
  };

  # xsession.pointerCursor = {
  #   package = pkgs.vanilla-dmz;
  #   name = "Vanilla-DMZ";
  # };

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
