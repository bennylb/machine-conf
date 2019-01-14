{ config, pkgs, ... }:

{
  users.groups = { realtime = { }; };
  users.extraUsers.ben.extraGroups = [ "realtime" ];
  security.pam.loginLimits = [
    { domain = "@realtime"; type = "-"; item = "rtprio"; value = "99"; }
    { domain = "@realtime"; type = "-"; item = "memlock"; value = "unlimited"; }
  ];
}
