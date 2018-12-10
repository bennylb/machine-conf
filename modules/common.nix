{ pkgs, ... }:

{

  # Select internationalisation properties.
  i18n = {
    # consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_AU.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  environment.systemPackages = with pkgs; [
    # system tools/utilities
    psmisc
    file
    htop
    tree
    fd
    ripgrep
    bat
    tealdeer
    rxvt_unicode
    xfce.terminal
    # network/web
    (qutebrowser.override { withPdfReader = false; withMediaPlayback = false; })
    chromium
    youtube-dl
    ncat
    wget
    nethogs
    # security
    openssl
    gnutls
    gnupg
    pass
    # media/graphics
    mpv
    inkscape
    # misc
    # (hunspellWithDicts [ hunspellDicts.en-gb-ise ])
    (aspellWithDicts (ps: [ ps.en ]))
    # development
    emacs26
    vim
    gnumake
    git
    # grml-zsh-config
    antigen
    direnv
    fasd
    # nix pkg management
    nox
    pypi2nix
    nix-prefetch-git
    # virtualisation
    docker
    docker_compose
  ];

  environment.variables = {
    DICPATH="";
  };

  nix.useSandbox = true;

  nixpkgs = {
    overlays =
      let path = /home/ben/.config/nixpkgs/overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));

    config = {
      allowUnfree = true;
      # firefox.enableBrowserpass = true;
    };
  };

  documentation = {
    enable = true;
    man.enable = true;
    info.enable = true;
    nixos.enable = true;
  };

  security = {
    sudo.enable = true;
    sudo.wheelNeedsPassword = true;
    sudo.extraConfig = ''
      Defaults:ben env_keep+=HOME
      Defaults !tty_tickets
      Defaults timestamp_timeout=240
    '';

    polkit.enable = true; # default
  };


  programs = {
    bash.promptInit = "";
    bash.enableCompletion = true;
    zsh.enable = true;
    zsh.promptInit = "";
    zsh.enableCompletion = true;
    zsh.interactiveShellInit = ''
      # source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
      source ${pkgs.antigen}/share/antigen/antigen.zsh
    '';
    fish.enable = true;
    tmux.enable = true;
    # light only needed when using X modesetting as xbacklight isn't available
    # programs.light.enable = true;
    gnupg.agent = {
      enable = false;
      enableSSHSupport = true;
    };
    browserpass.enable = true;
    dconf.enable = true;
  };

  sound.enable = true;

  services = {
    dbus.packages = [ pkgs.gnome3.dconf ];
    gnome3.gnome-keyring.enable = true;
    emacs.package = pkgs.emacs26;
    emacs.install = true;
    unclutter-xfixes.enable = false;
    redshift = {
      enable = true;
      provider = "manual";
      latitude = "-38.1";
      longitude = "145.2";
    };
  };

  fonts = {
    fontconfig = {
      penultimate.enable = false;
      ultimate.enable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.ben = {
    isNormalUser = true;
    home = "/home/ben";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };
}
