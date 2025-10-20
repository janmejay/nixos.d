{ config, pkgs, lib, ... }:
{
  imports = [
    ./shared.nix
    ./emacs.nix
    ./http-cache.nix
    ./linux.nix
  ];
}
