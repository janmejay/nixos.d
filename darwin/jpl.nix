{ pkgs, ... }:
{
  networking.computerName = "jpl";
  networking.hostName = "jpl";
  environment.systemPackages = [
    pkgs.obsidian
    pkgs.google-chrome
    pkgs.kitty
    pkgs.git
    pkgs.nixvim
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
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllFiles = true;
  };
}
