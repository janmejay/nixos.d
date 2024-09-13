{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../common-configuration.nix
    ];

  networking.hostName = "jdell";

  boot.supportedFilesystems = [ "ext4" ];

  system.stateVersion = "24.05"; # never change
}

