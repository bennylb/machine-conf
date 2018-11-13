self: super:
{
  # inkscape =
  #   super.inkscape.overrideAttrs (oldAttrs: {
  #     propagatedBuildInputs =
  #       oldAttrs.propagatedBuildInputs ++
  #         (with self.python3Packages; [ tldextract ]);
  #   });
}
