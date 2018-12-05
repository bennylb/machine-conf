{ pkgs, ... }:

{
  security.pam.services.i3lock.enableGnomeKeyring = true;

  systemd.user.services.xssi3lock = {
    description = "xss-lock and i3lock locker service";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Environment = "DISPLAY=:0";
      ExecStart = "${pkgs.xss-lock}/bin/xss-lock -l -- ${pkgs.i3lock}/bin/i3lock -n -i /home/ben/machine-conf/share/backgrounds/nix-wallpaper-simple-dark-gray_bottom_1920x1080.png";
      Restart = "always";
    };
  };

  services.xserver.windowManager.i3 = {
    configFile = "/home/ben/.config/i3/config";
    extraPackages = with pkgs; [
      # i3pystatus
      i3status-rust
      xorg.xbacklight
      xdg_utils
      xss-lock
      unclutter-xfixes
      dmenu
      rofi
      clipster
      gnome3.gnome_themes_standard
      networkmanagerapplet
      gnome3.seahorse
      polkit_gnome
    ];
  };
}
