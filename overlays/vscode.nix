self: super:

{
  vscode-with-extensions = super.vscode-with-extensions.override {
    vscodeExtensions =
      super.vscode-utils.extensionsFromVscodeMarketplace [

      ] ++ (with super.vscode-extensions; [
        bbenoist.Nix
      ]);
  };
}
