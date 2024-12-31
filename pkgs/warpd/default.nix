{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libXfixes,
  libXext,
  libXinerama,
  libXi,
  libXtst,
  libX11,
  libXft,
}:
let
  warpd = stdenv.mkDerivation rec {
    pname = "warpd";
    version = "1.3.7-win+";

    src = fetchFromGitHub {
      owner = "janmejay";
      repo = "warpd";
      rev = "879c9a6fa58c0b11144c951318977f72fd3f7b3f";
      hash = "sha256-hN6AF5OGU3A9KrpWNO8NKcUID6+1XrWtgRfITsjZg8k=";
    };

    buildInputs = [libXfixes libXext libXinerama libXi libXtst libX11 libXft];

    buildPhase = ''
      PREFIX=${placeholder "out"} DESTDIR="" DISABLE_WAYLAND=1 make
    '';

    installPhase = ''
      PREFIX=${placeholder "out"} DESTDIR="" make install
    '';

    enableParallelBuilding = true;

    postInstall = ''
      rm -rf $out/etc
    '';

    meta = with lib; {
      description = "A modal keyboard driven interface for mouse manipulation.";
      license = licenses.mit;
      maintainers = with maintainers; [peterhoeg];
      platforms = platforms.linux;
    };
  };
in
warpd
