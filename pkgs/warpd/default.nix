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
      owner = "rvaiya";
      repo = "warpd";
      rev = "01650eabf70846deed057a77ada3c0bbb6d97d6e";
      hash = "sha256-61+kJvOi4oog0+tGucc1rWemdx2vp15wlluJE+1PzTs=";
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
