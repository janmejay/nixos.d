{ config, pkgs, inputs, nixvim, ... }:
let
  user = "janmejay";
in
{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  # Install nixvim distribution
  programs.nixvim.enable = true;
  programs.nixvim.package = nixvim.packages.${pkgs.system}.default;

  # Common macOS tools
  home.packages = with pkgs; [
    obsidian
    kitty
    tmux
    ripgrep
    fd
    bat
    eza
    git
    google-chrome
  ];

  programs.zsh.enable = true;
  programs.tmux.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Add more macOS/home-manager options as needed
}
