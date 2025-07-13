final: prev: {
  openrazer = prev.openrazer.overrideAttrs (old: {
    pname = "openrazer-git";
    version = "unstable-git";

    src = prev.fetchFromGitHub {
      owner = "openrazer";
      repo = "openrazer";
      rev = "267c5ec3c4dfac2fddc50e445b1a77e223d7091c";  # known working post-hrtimer fix
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # you'll fix this below
    };
  });
}
