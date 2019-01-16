# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/configuration.nix
    ../common/chromium.nix
    ../musnix
  ];

  musnix.enable = true;

  fileSystems."/boot" = {
    # device = "/dev/sda1";
    # fsType = "vfat";
    options = [ "defaults" "noatime" ];
  };

  fileSystems."/" = {
    # device = "/dev/sda2";
    # fsType = "btrfs";
    options = [ "defaults" "noatime" ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    # opengl.extraPackages = with pkgs; [ vaapiIntel ];
    pulseaudio.enable = false;
    # pulseaudio.package = pkgs.pulseaudio.override { jackaudioSupport = true; };
    pulseaudio.package = pkgs.pulseaudioFull;
  };

  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      grub = {
        enable = false;
        devices = [ "nodev" ];
        efiSupport = true;
        # useOSProber = true;
        extraEntries = ''
          menuentry "Microsoft Windows 7/8/8.1/10 UEFI/GPT" {
            insmod part_gpt
            # insmod part_msdos
            # insmod ntfs
            insmod fat
            insmod chain
            # insmod search_fs_uuid
            search --no-floppy --fs-uuid --set=root --hint-bios=hd1,gpt2 --hint-efi=hd1,gpt2 --hint-baremetal=ahci1,gpt2 B054757954754360
            chainloader /Windows/Boot/EFI/bootmgfw.efi
            # chainloader /bootmgr
          }
        '';
      };
    };
    # boot.kernelPackages = with pkgs; linuxPackages;
    kernelPackages = with pkgs; linuxPackages_4_19;
    blacklistedKernelModules = [ ];
    tmpOnTmpfs = true;
    cleanTmpDir = true;
  };

  virtualisation = {
    docker.enable = true;
  };

  networking = {
    hostName = "station"; # Define your hostname.
    firewall.enable = true;
    networkmanager.enable = true;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    chromium
    # redshift-plasma-applet
    plasma-browser-integration
    # kwalletcli
    (mpv.override { jackaudioSupport = true; })
    google-play-music-desktop-player
    # virtualisation
    qemu
    docker
    docker_compose
  ];

  nix.useSandbox = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      firefox.enableBrowserpass = true;
      firefox.enablePlasmaBrowserIntegration = true;
    };
  };

  documentation = {
    enable = true;
    man.enable = true;
    info.enable = true;
    # nixos.enable = true;
  };

  security = {
    pam.services.sddm.enableKwallet = true;
    polkit.enable = true;
  };

  programs = {
    browserpass.enable = true;
  };

  sound.enable = true;
  sound.extraConfig = ''
    pcm.!default {
       type hw
       card DAC
       format S16_LE
       rate 44100
    }

    ctl.!default {
      type hw
      card DAC
    }
  '';

  # defaults.pcm.card DAC;

  powerManagement.enable = true;

  services = {
    unclutter-xfixes.enable = false;
    openssh.enable = true;
    openssh.passwordAuthentication = false;
    printing.enable = true;
    fstrim.enable = true;
    redshift = {
      enable = true;
      provider = "manual";
      latitude = "-38.1";
      longitude = "145.2";
      brightness = {
        day = "1"; # default 1
        night = "1"; # default 1
      };
      temperature = {
        day = 5500; # default 5500
        night = 3700; # default 3700
      };
    };
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      libinput = {
        enable = true;
      };
      videoDrivers = [
        "nvidia"
      ];
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };
  };

  # Font config
  fonts = {
    fontconfig = {
      penultimate.enable = false; # default true
      ultimate.enable = false;
    };
    fonts = [
      pkgs.dejavu_fonts
      pkgs.liberation_ttf
      pkgs.ubuntu_font_family
      pkgs.source-code-pro
    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
