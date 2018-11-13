with import <nixpkgs> {};

let
  python = import ./requirements.nix { inherit pkgs; };
in
  python.mkDerivation {
    name = "qute-config-env";
    buildInputs = ([
      bashInteractive
    ] ++ (builtins.attrValues python.packages));
  }
