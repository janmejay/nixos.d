{ config, pkgs, inputs, nixvim, ... }:
{
  home.stateVersion = "24.05";

  imports = [ ./modules  ];
  
  osx.enable = true;
  nixvim.enable = true;
}
