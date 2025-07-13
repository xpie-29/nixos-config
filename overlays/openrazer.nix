final: prev: {
  openrazer = prev.stdenv.mkDerivation rec {
    pname = "openrazer";
    version = "3.7.0";

    src = prev.fetchFromGitHub {
      owner = "openrazer";
      repo = "openrazer";
      rev = "v3.7.0";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    nativeBuildInputs = with prev; [ python3 python3Packages.setuptools ];

    buildPhase = ''
      echo "Nothing to build explicitly"
    '';

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';

    meta = with prev.lib; {
      description = "OpenRazer driver and tools";
      homepage = "https://github.com/openrazer/openrazer";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
  };
}
