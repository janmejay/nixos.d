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
    version = "1.3.5";

    src = fetchFromGitHub {
      owner = "rvaiya";
      repo = "warpd";
      rev = "v" + version;
      hash = "sha256-YHTQ5N4SZSa3S3sy/lNjarKPkANIuB2khwyOW5TW2vo=";
    };

    postPatch = ''
      substituteInPlace Makefile \
        --replace DESTDIR= DESTDIR=${placeholder "out"} \
        --replace /usr ""
    '';

    buildInputs = [libXfixes libXext libXinerama libXi libXtst libX11 libXft];

    buildPhase = ''
      PLATFORM=x11 make
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
