{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, qtbase
, qtsvg
, qttools
, qtdeclarative
, libXfixes
, libXtst
, qtwayland
, wayland
, wrapQtAppsHook
, kdePackages
}:

stdenv.mkDerivation rec {
  pname = "CopyQ";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "janmejay";
    repo = "CopyQ";
    rev = "f4290758924f1c410e7ac34c180fae6bcebad27a";
    hash = "";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
    qttools
    qtdeclarative
    libXfixes
    libXtst
    qtwayland
    wayland
    kdePackages.kconfig
    kdePackages.kstatusnotifieritem
    kdePackages.knotifications
  ];

  postPatch = ''
    substituteInPlace shared/com.github.hluk.copyq.desktop.in \
      --replace copyq "$out/bin/copyq"
  '';

  cmakeFlags = [ "-DWITH_QT6=ON" ];

  meta = with lib; {
    homepage = "https://hluk.github.io/CopyQ";
    description = "Clipboard Manager with Advanced Features";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ artturin ];
    # NOTE: CopyQ supports windows and osx, but I cannot test these.
    platforms = platforms.linux;
    mainProgram = "copyq";
  };
}