# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/common.nix
    ./modules/i3.nix
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

  # List packages installed in system profile. To search by name, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    unzip
    gptfdisk
    powertop
    libva
  ];

  nixpkgs = {
    config = {
      mpv.vaapiSupport = true;
    };
  };

  security = {
    pam.services.lightdm.enableGnomeKeyring = true;
    pam.services.lightdm-greeter.enableGnomeKeyring = true;
    # pam.services.lightdm.text = (pkgs.stdenv.lib.mkDefault ''
    #   auth        optional    /run/current-system/sw/lib/security/pam_gnome_keyring.so
    #   session     optional    /run/current-system/sw/lib/security/pam_gnome_keyring.so    auto_start
    # '');
  };

  programs = {
    fish.enable = true;
  };

  powerManagement.enable = true;

  services = {
    tlp.enable = true;

    udisks2.enable = true;

    logind.extraConfig = ''
      IdleActionSec=15min
      IdleAction=suspend
      HandleLidSwitch=suspend
      HandlePowerKey=suspend
    '';

    xserver = {
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
        default = "i3";
      };
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

  # Enable the X11 windowing system.

  # Font config
  fonts = {
    fonts = [
      pkgs.dejavu_fonts
      pkgs.liberation_ttf
      pkgs.ubuntu_font_family
      pkgs.source-code-pro
    ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  # system.stateVersion = "16.09";
  system.stateVersion = "18.03";
  # system.nixos.stateVersion = "18.03";

}
