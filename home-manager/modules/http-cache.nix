{ config, pkgs, lib, ... }:
let
  cfg = config.http-cache;
in
{
  options.http-cache = {
    enable = lib.mkEnableOption "Setup local http-cache";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs = {
      config = {
        permittedInsecurePackages = [ "squid-6.12" ];
      };
    };

    home.packages = with pkgs; [
      squid
    ];
    
    home.file = { 
       "projects/rubrik/squid.d/run.sh" = {
         source = ../../dots/squid.run.sh;
         executable = true;
       };
       "projects/rubrik/squid.d/conf/squid.conf" = {
         source = ../../dots/squid.conf;
       };
    };
  };
}
