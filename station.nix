# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  fileSystems."/boot" = {
    # device = "/dev/sda1";
    # fsType = "vfat";
    options = [ "defaults" "noatime" ];
  };

  fileSystems."/" = {
    # device = "/dev/sda2";
    # fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };

  fileSystems."/home" = {
    # device = "/dev/sda4";
    # fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl.extraPackages = with pkgs; [ vaapiIntel ];
    pulseaudio.enable = false;
  };

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.systemd-boot.editor = false;
    loader.efi.canTouchEfiVariables = true;

    # boot.kernelPackages = with pkgs; linuxPackages;
    kernelPackages = with pkgs; linuxPackages_4_19;
    # boot.kernelParams = [ "scsi_mod.use_blk_mq=y"
    #                       "dm_mod.use_blk_mq=y" ];
    blacklistedKernelModules = [
      "psmouse"
      # "mei_me"
      # "mei"
    ];
    extraModprobeConfig = ''
      options snd_hda_intel index=1,0
    '';
    tmpOnTmpfs = true;
    cleanTmpDir = true;
  };

  virtualisation.docker.enable = true;

  networking = {
    hostName = "sputnik"; # Define your hostname.
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n = {
    # consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_AU.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # List packages installed in system profile. To search by name, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # utilities
    psmisc
    unzip
    gptfdisk
    htop
    tree
    fd
    ripgrep
    bat
    tealdeer
    powertop
    rxvt_unicode
    xfce.terminal
    # web/network
    networkmanagerapplet
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
    # (pinentry.override { libsecret = pkgs.libsecret; })
    pass
    gnome3.seahorse
    polkit_gnome
    # video accel
    libva
    # X/desktop
    xorg.xbacklight
    xdg_utils
    xss-lock
    unclutter-xfixes
    i3pystatus
    dmenu
    rofi
    clipster
    gnome3.gnome_themes_standard
    mpv
    (inkscape.override { scourSupport = true; })
    # (hunspellWithDicts [ hunspellDicts.en-gb-ise ])
    (aspellWithDicts (ps: [ ps.en ]))
    # development
    emacs
    vim
    gnumake
    git
    # grml-zsh-config
    antigen
    direnv
    # nix pkg management
    home-manager
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
      mpv.vaapiSupport = true;
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

    pam.services.lightdm.enableGnomeKeyring = true;
    pam.services.lightdm-greeter.enableGnomeKeyring = true;
    pam.services.i3lock.enableGnomeKeyring = true;
    # pam.services.lightdm.text = (pkgs.stdenv.lib.mkDefault ''
    #   auth        optional    /run/current-system/sw/lib/security/pam_gnome_keyring.so
    #   session     optional    /run/current-system/sw/lib/security/pam_gnome_keyring.so    auto_start
    # '');

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

  powerManagement.enable = true;

  systemd.user.services.xssi3lock = {
    description = "xss-lock and i3lock locker service";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Environment = "DISPLAY=:0";
      # ExecStartPre = "${pkgs.xorg.xset}/bin/xset s 600";
      ExecStart = "${pkgs.xss-lock}/bin/xss-lock -l -- ${pkgs.i3lock}/bin/i3lock -n -i /home/ben/Pictures/nix-wallpaper-simple-dark-gray_bottom_1920x1080.png";
      Restart = "always";
    };
  };

  services = {
    dbus.packages = [ pkgs.gnome3.dconf ];
    gnome3.gnome-keyring.enable = true;
    tlp.enable = true;
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

  systemd.services = {
    fstrim = {
      description = "Discard unused blocks";
      path = [ pkgs.utillinux ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.utillinux}/bin/fstrim -av";
      };
    };
  };

  systemd.timers = {
    fstrim = {
      description = "Discard unused blocks once a week";
      timerConfig = {
        OnCalendar = "weekly";
        AccuracySec = "6h";
        Unit = "fstrim.service";
        Persistent = true;
      };
      wantedBy = ["timers.target"];
    };
  };

  services.logind.extraConfig = ''
    IdleActionSec=15min
    IdleAction=suspend
    HandleLidSwitch=suspend
    HandlePowerKey=suspend
  '';

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    serverFlagsSection = ''
      Option "BlankTime"   "10"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime"     "0"
    '';
    inputClassSections =
    [
      ''
        Identifier "touchpad"
        MatchProduct "DLL0665:01 06CB:76AD Touchpad"
        Driver "libinput"
      ''
    ];
    libinput = {
      enable = true;
      tapping = true;
      disableWhileTyping = true;
      horizontalScrolling = true;
      naturalScrolling = true;
      accelSpeed = "0.25";
      accelProfile = "adaptive";
    };
    # The following two drivers require libva and vaapiIntel packages for
    # hardware accelerated video i.e mpv with vaapi support.
    videoDrivers = [
      "intel"
      # "modesetting"
    ];
    # When using modesetting enable glamor.
    # useGlamor = true;
    displayManager.lightdm.enable = true;
    windowManager = {
      i3.enable = true;
      i3.configFile = "/home/ben/.config/i3/config";
      default = "i3";
    };
  };

  # Font config
  fonts = {
    fontconfig = {
      penultimate.enable = false;
      ultimate.enable = true;
    };
    fonts = [
      pkgs.dejavu_fonts
      pkgs.liberation_ttf
      pkgs.ubuntu_font_family
      pkgs.source-code-pro
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.ben = {
    isNormalUser = true;
    home = "/home/ben";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  # system.stateVersion = "16.09";
  system.stateVersion = "18.03";
  # system.nixos.stateVersion = "18.03";

}
