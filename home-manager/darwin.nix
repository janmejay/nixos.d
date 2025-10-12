{ config, pkgs, inputs, nixvim, ... }:
let
  user = "janmejay";
in
{
  nixpkgs.config.allowUnfree = true;
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  programs.nixvim = {
    config = {
      enable = true;
      globals.mapleader = " ";
      colorschemes.catppuccin.enable = true;
      plugins = { 
        lualine.enable = true;
        telescope = {
          enable = true;
  	extensions = {
  	  fzf-native.enable = true;
  	};
        };
        mini = {
          enable = true;
          modules.icons = { };
          mockDevIcons = true;
        };
      };
    };

    options = {
       relativenumber = true;
       shiftwidth = 2;
     };

  };

  # Common macOS tools
  home.packages = with pkgs; [
    sops
    # nixvim.packages.${pkgs.system}.default
  ];

  programs.zsh.enable = true;
  programs.tmux.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Add more macOS/home-manager options as needed
}
