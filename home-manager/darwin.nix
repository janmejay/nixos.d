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
    enable = true;

    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };

  # Common macOS tools
  home.packages = with pkgs; [
    sops
  ];

  programs.zsh.enable = true;
  programs.tmux.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Add more macOS/home-manager options as needed
}
