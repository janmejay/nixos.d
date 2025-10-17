{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  networking.computerName = "jpl";
  networking.hostName = "jpl";
  environment.systemPackages = with pkgs; [
    obsidian
    google-chrome
    kitty
    git
    neovim
    home-manager
    tmux
    ripgrep
    fd
    bat
    eza
    zsh
  ];
  users.users.janmejay = {
    home = "/Users/janmejay";
    shell = pkgs.zsh;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [ 
    	"karabiner-elements"
	"intellij-idea-ce"
	"shortcat"
    ];
  };
  programs.zsh.enable = true;
  nix = {
    enable = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  system = {
    stateVersion = 6;
    primaryUser = "janmejay";
    defaults = {
      dock.autohide = true;
      finder.AppleShowAllFiles = true;
      loginwindow.GuestEnabled = false;
    };
  };
}
