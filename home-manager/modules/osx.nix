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


    home.file = {
      ".config/karabiner/assets/complex_modifications/cmd_ctrl.json".source = ../../dots/karabiner/complex_modifications/cmd_ctrl.json;
      ".config/aerospace/aerospace.toml".source = ../../dots/aerospace.toml;
    };

  };
}
