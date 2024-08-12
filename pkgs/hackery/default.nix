{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libXfixes,
  xorgproto,
  libX11,
}:
let
  hackery = stdenv.mkDerivation rec {
    pname = "hackery";
    version = "0.0.1";

    src = fetchFromGitHub {
      owner = "janmejay";
      repo = "dev_utils";
      rev = "faa11a47428e318d432e9aafc72af62797ab3d0b";
      hash = "sha256-VLLgyOa7OXdFgXYwej10YNLDabgmSgAdnO9feaQqk2w=";
    };

    buildInputs = [libXfixes xorgproto libX11];

    buildPhase = ''
      (cd hackery && make hide_mouse_ptr)
    '';

    installPhase = ''
      install -D hackery/hide_mouse_ptr ${placeholder "out"}/bin/hide_mouse_ptr
    '';

    enableParallelBuilding = true;

    meta = with lib; {
      description = "Some hacks that make local env work.";
      license = licenses.mit;
      maintainers = with maintainers; [peterhoeg];
      platforms = platforms.linux;
    };
  };
in
hackery