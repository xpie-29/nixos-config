final: prev: {
  openrazer = prev.openrazer.overrideAttrs (old: {
    pname = "openrazer";
    version = "3.7.0";

    src = prev.fetchFromGitHub {
      owner = "openrazer";
      repo = "openrazer";
      rev = "v3.7.0";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # placeholder
    };
  });
}
