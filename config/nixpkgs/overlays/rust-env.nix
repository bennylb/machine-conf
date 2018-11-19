self: super: {

rustEnv = let

  moz-overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz-overlay ]; };
  myrust = (nixpkgs.rustChannels.nightly.rust.override { extensions = [ "rust-src" ]; });

in with nixpkgs; super.buildEnv {

  name = "rust-env";
  paths = [
    gcc
    # latest.rustChannels.nightly.rust
    myrust
    rustracer
  ];

};

}
