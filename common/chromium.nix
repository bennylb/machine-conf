{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "iaiomicjabeggjcfkbimgmglanimpnae" # vimium
      "dbepggeogbaibhgnhhndojpepiihcmeb" # tab session manager
      "naepdomgkenhinolocfifgehidddafch" # browserpass-ce
      # "cimiefiiaegbelhefglklhhakcgmhkai" # plasma integration
    ];
  };
}

