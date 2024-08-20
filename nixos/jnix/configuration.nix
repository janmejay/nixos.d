{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../common-configuration.nix
    ];

  networking.hostName = "jnix";

  system.stateVersion = "24.05"; # never change
}

