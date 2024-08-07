{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "warpd";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "warpd";
    rev = "v" + version;
    hash = "";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace DESTDIR= DESTDIR=${placeholder "out"} \
      --replace /usr ""
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
}
