{ config, pkgs, inputs, lib, ... }:
let
  warpd = pkgs.callPackage ../pkgs/warpd {};
  hackery = pkgs.callPackage ../pkgs/hackery {};
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
    warpd
    hackery
    bat
    fzf
    silver-searcher
    jq
    tree
    eza
    git
    firefox
    google-chrome
    copyq
    rxvt-unicode
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
      rev = "d883c676feff6c1e3e97dfed02dfd4012186ff16";
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
  };

  programs.zsh.oh-my-zsh= {
    enable = true;
    plugins = ["git" "python" "docker" "fzf"];
    theme = "dpoggi";
  };

}