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
    ../common/home-common.nix
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
      ".fehbg".source = "${repoPath}/fehbg";
      ".gnupg/gpg-agent.conf".source = "${repoPath}/gnupg/gpg-agent.conf";
      ".gnupg/gpg.conf".source = "${repoPath}/gnupg/gpg.conf";
    };
  };

  xdg = {
    enable = true;

    configFile = {
      "alacritty/alacritty.yml".source = "${repoPath}/config/alacritty/alacritty.yml";
      "clipster/clipster.ini".source = "${repoPath}/config/clipster/clipster.ini";
      "i3/config".source = "${repoPath}/config/i3/config";
      "i3/pystatus.py".source = "${repoPath}/config/i3/pystatus.py";
      "i3/rsstatus.toml".source = "${repoPath}/config/i3/rsstatus.toml";
      "mpv/mpv.conf".source = "${repoPath}/config/mpv/mpv-sputnik.conf";
      "mpv/scripts/dev/select-ao.lua".source = "${repoPath}/config/mpv/scripts/dev/select-ao.lua";
      "qutebrowser/bookmarks/urls".source = "${repoPath}/config/qutebrowser/bookmarks/urls";
      "qutebrowser/config.py".source = "${repoPath}/config/qutebrowser/config.py";
      "qutebrowser/quickmarks".source = "${repoPath}/config/qutebrowser/quickmarks";
      "direnv/direnvrc".source = "${repoPath}/example-nix/tools/direnv/direnvrc";
      "doom" = {
        source = "${repoPath}/config/doom";
        recursive = true;
      };
    };

    dataFile = {
      "qutebrowser/userscripts/org_capture".source = "${repoPath}/share/qutebrowser/userscripts/org_capture";
      "qutebrowser/userscripts/yank_org_link".source = "${repoPath}/share/qutebrowser/userscripts/yank_org_link";
      "zsh/site-functions/prompt_pure_setup".source = "${repoPath}/pure/pure.zsh";
      "zsh/site-functions/async".source = "${repoPath}/pure/async.zsh";
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
