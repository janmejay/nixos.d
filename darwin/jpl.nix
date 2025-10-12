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
    casks = [ ];
  };
  programs.zsh.enable = true;
  nix = {
    enable = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  services.karabiner-elements = {
    enable = true;
    package = pkgs.karabiner-elements.overrideAttrs (old: {
      version = "14.13.0";

      src = pkgs.fetchurl {
        inherit (old.src) url;
        hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
      };

      dontFixup = true;
    });
  };

  system.stateVersion = 6;
  system.primaryUser = "janmejay";
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllFiles = true;
  };
}
