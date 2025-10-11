{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  networking.computerName = "jpl";
  networking.hostName = "jpl";
  environment.systemPackages = [
    pkgs.obsidian
    pkgs.google-chrome
    pkgs.kitty
    pkgs.git
    pkgs.neovim
    pkgs.home-manager
    pkgs.tmux
    pkgs.ripgrep
    pkgs.fd
    pkgs.bat
    pkgs.eza
    pkgs.zsh
  ];
  users.users.janmejay = {
    home = "/Users/janmejay";
    shell = pkgs.zsh;
  };
  homebrew = {
    enable = true;
    casks = [];
  };
  programs.zsh.enable = true;
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };
  nix = {
    enable = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = 6;
  system.primaryUser = "janmejay";
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllFiles = true;
  };
}
