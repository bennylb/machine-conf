self: super: {

  clipster = super.clipster.overrideAttrs (oldAttrs: {
    src = super.fetchFromGitHub {
      owner = "bennylb";
      repo = "clipster";
      rev = "5c8acb39722c8d5d0f42cf2ecda2e1f1dac2596b";
      sha256 = "1kifnkxy0sh9h1xhchwc5haa541czrddq01j9kky9klaxmzlhkd1";
    };
  });
}
