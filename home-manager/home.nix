{ config, pkgs, inputs, lib, ... }:
let
  warpd = pkgs.callPackage ../pkgs/warpd {};
  hackery = pkgs.callPackage ../pkgs/hackery {};
  find-cursor = pkgs.callPackage ../pkgs/find-cursor {};

  dev-utils = builtins.fetchGit {
    url = "https://github.com/janmejay/dev_utils.git";
    rev = "e333ec09a0d1f5d79d63d50c144ea3470ae2a776";
    submodules = true;
    ref = "master";
  };
  user="janmejay";
in {
  home.username = user;
  home.homeDirectory = /home/${user};
  home.stateVersion = "24.05";
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        "squid-6.12"
      ];
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
    patchelf
    sysstat
    timg
    xorg.xkill
    moreutils
    sops
    pistol
    tcpdump
    gcc
    nix-index
    graphviz
    vscode-fhs
    (jetbrains.plugins.addPlugins jetbrains.idea-community [ "github-copilot" ])
    squid
    dig
    bc
    rlwrap
    xautolock
    i3lock
    zoom-us
    pavucontrol
    wireplumber
    networkmanagerapplet
    xclip
    xfce.xfce4-screenshooter
    xfce.thunar
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
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    gimp
    feh
    pstree
    ffmpeg
    vlc
    file
    openjdk
    nodejs
    neovim
    fd
    ripgrep
  ];

  home.sessionVariables = {
    EDITOR="nvim";
  };
  home.shellAliases = {
    l = "eza";
    c = "bat";
  };

  home.file = {
    ".config" = {
      source = ../dots/dot_config;
      recursive = true;
    };
    ".gitconfig".source = ../dots/gitconfig;
    ".dev_utils".source = dev-utils;
    ".jq".source = "${dev-utils}/rc/jq";
    ".tmux.conf".source = ../dots/tmux.conf;
    ".Xdefaults".source = ../dots/Xdefaults;
    ".my.emacs.d".source = builtins.fetchGit {
      url = "https://github.com/janmejay/emacs";
      rev = "a0b42cac2241928ba054f660559e2ac9e068b7b1";
      ref = "nixos";
    };
    ".emacs".source = ../dots/emacs;
    "projects/rubrik/squid.d/run.sh" = {
      source = ../dots/squid.run.sh;
      executable = true;
    };
    "projects/rubrik/squid.d/conf/squid.conf" = {
      source = ../dots/squid.conf;
    };
  };

  fonts.fontconfig.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
    source ~/.dev_utils/rc/shared_shell_config
    DEFAULT_USER=${user}
    prompt_context() {
      if (( $SHLVL > 1 )) ; then
        n=$(echo $name | sed -re "s/,.+//")
        prompt_segment white black "$n/$SHLVL"
      fi
    }
    '';
    oh-my-zsh= {
      enable = true;
      plugins = ["git" "python" "docker" "fzf"];
      theme = "agnoster";
    };
  };

  programs.kitty = {
    enable = true;
    themeFile = "3024_Night";
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "DejaVu Sans Mono";
      size = 15.5;
    };
    extraConfig = "enable_audio_bell no";
  };
}
