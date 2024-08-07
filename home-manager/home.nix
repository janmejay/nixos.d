{ config, pkgs, inputs, lib, ... }:

{
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
      rev = "faa11a47428e318d432e9aafc72af62797ab3d0b";
    };
    ".tmux.conf".source = ../dots/tmux.conf;
  };

  programs.zsh = {
    enable = true;
  };

  programs.zsh.oh-my-zsh= {
    enable = true;
    plugins = ["git" "python" "docker" "fzf"];
    theme = "dpoggi";
  };

}