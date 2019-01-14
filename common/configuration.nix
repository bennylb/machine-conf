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
    ntfs3g
    xclip
    # woeusb
    # network/web
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
    inkscape
    # misc
    # (hunspellWithDicts [ hunspellDicts.en-gb-ise ])
    (aspellWithDicts (ps: [ ps.en ]))
    # development
    emacs26
    emacs-all-the-icons-fonts
    vimHugeX
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
  ];

  environment.variables = {
    DICPATH="";
  };

  nix.useSandbox = true;

  nixpkgs = {
     overlays =
       let path = ../overlays; in with builtins;
       map (n: import (path + ("/" + n)))
           (filter (n: match ".*\\.nix" n != null ||
                       pathExists (path + ("/" + n + "/default.nix")))
                   (attrNames (readDir path)));
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
    tmux.enable = true;
    # light only needed when using X modesetting as xbacklight isn't available
    # programs.light.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  sound.enable = true;

  services = {
    emacs.package = pkgs.emacs26;
    emacs.install = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.ben = {
    isNormalUser = true;
    home = "/home/ben";
    extraGroups = [ "wheel" "audio" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };

}
