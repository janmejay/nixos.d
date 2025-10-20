{ config, pkgs, lib, ... }:
let
  cfg = config.osx;
in
{
  options.osx = {
    enable = lib.mkEnableOption "Pull osx specific config / pkgs";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ ];
  };
}
