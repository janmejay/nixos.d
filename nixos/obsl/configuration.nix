{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../common-configuration.nix
    ];

  fileSystems."/" = lib.mkForce {
    device = "/dev/rt/root";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/rt/swap"; } ];

  networking.hostName = "obsl";

  boot.supportedFilesystems = [ "ext4" "lvm" ];

  system.stateVersion = "24.05"; # never change
}

