{ config, pkgs, lib, ... }:
let
  cfg = config.emacs;
in
{
  options.emacs = {
    enable = lib.mkEnableOption "Setup emacs config-dir";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      emacs
      fd
    ];
    
    home.file = { 
       ".my.emacs.d".source = builtins.fetchGit {
         url = "https://github.com/janmejay/emacs";
         rev = "a0b42cac2241928ba054f660559e2ac9e068b7b1";
         ref = "nixos";
       };
       ".emacs".source = ../../dots/emacs;
    };
  };
}
