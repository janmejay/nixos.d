{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libXfixes,
  libXext,
  libX11,
  libXdamage,
  libXrender,
}:
let
  find-cursor = stdenv.mkDerivation rec {
    pname = "find-cursor";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "janmejay";
      repo = "find-cursor";
      rev = "d59ed61d3c59968ab4d2801ff345be23b54cb47b";
      hash = "sha256-ZcMSVKD7AGAwKFhP+aXgtsKwLw8CT0aeEz08Go4yvnQ=";
    };

    buildInputs = [libXfixes libXext libX11 libXdamage libXrender];

    installPhase = ''
      PREFIX=${placeholder "out"} DESTDIR="" make install
    '';

    meta = with lib; {
      description = "Point out hidden cursor.";
      license = licenses.mit;
      maintainers = with maintainers; [peterhoeg];
      platforms = platforms.linux;
    };
  };
in
find-cursor