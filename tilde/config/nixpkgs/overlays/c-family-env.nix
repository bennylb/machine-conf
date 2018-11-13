self: super: {

cFamilyEnv = super.buildEnv {
  name = "c-family-env";
  paths = with super; [
    gcc
    bear
    python
    ycmd
    clang
  ];
};

}
