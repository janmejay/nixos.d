{ config, pkgs, inputs, lib, ... }:
let
  warpd = pkgs.callPackage ../pkgs/warpd {};
  hackery = pkgs.callPackage ../pkgs/hackery {};
  copyq = pkgs.qt6.callPackage ../pkgs/copyq {};
  find-cursor = pkgs.callPackage ../pkgs/find-cursor {};

  rxvt-unicode-unwrapped =
      let fix-osc-response = pkgs.fetchpatch {
        name = "fix-osc-responses-with-7-bit-st.patch";
        url = "https://github.com/exg/rxvt-unicode/commit/417b540d6dba67d440e3617bc2cf6d7cea1ed968.patch";
        sha256 = "hnRfQc4jPiBrm06nJ3I7PHdypUc3jwnIfQV3uMYz+/Y=";
      };
    in
      pkgs.rxvt-unicode-unwrapped.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [fix-osc-response];
      });
in {
  home.username = "janmejay";
  home.homeDirectory = "/home/janmejay";
  home.stateVersion = "24.05";
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    # local (custom) v
    warpd
    hackery
    copyq
    find-cursor

    # public v
    xautolock
    i3lock
    zoom-us
    pavucontrol
    networkmanagerapplet
    xclip
    xfce.xfce4-screenshooter
    nomacs # image viewer
    gnumake
    bat
    fzf
    silver-searcher
    jq
    tree
    eza
    git
    firefox
    google-chrome
    rxvt-unicode-unwrapped
    tmux
    python3
    lsof
    gdb
    bash
    cascadia-code
    dejavu_fonts
    powerline-fonts
    ubuntu-sans-mono
    intel-one-mono
    source-code-pro
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
  ];

  home.sessionVariables = {
    EDITOR="emacs";
  };
  home.shellAliases = {
    l = "eza";
    ls = "eza";
    cat = "bat";
  };

  home.file = {
    ".config" = {
      source = ../dots/dot_config;
      recursive = true;
    };
    ".gitconfig".source = ../dots/gitconfig;
    ".dev_utils".source = builtins.fetchGit {
      url = "https://github.com/janmejay/dev_utils.git";
      rev = "e5e461a764886b081252d606e3868456545e4a35";
      submodules = true;
      ref = "nixos";
    };
    ".tmux.conf".source = ../dots/tmux.conf;
    ".Xdefaults".source = ../dots/Xdefaults;
    ".my.emacs.d".source = builtins.fetchGit {
      url = "https://github.com/janmejay/emacs";
      rev = "a0b42cac2241928ba054f660559e2ac9e068b7b1";
      ref = "nixos";
    };
    ".emacs".source = ../dots/emacs;

  };

  fonts.fontconfig.enable = true;

  programs.zsh = {
    enable = true;
    initExtra = ''
    source ~/.dev_utils/rc/shared_shell_config
    '';
  };

  programs.zsh.oh-my-zsh= {
    enable = true;
    plugins = ["git" "python" "docker" "fzf"];
    theme = "dpoggi";
  };
}