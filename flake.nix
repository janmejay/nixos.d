{
  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      home-mgr-cfg = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
            ./home-manager/home.nix
        ];
      };
    in {

      # build: 'nixos-rebuild --flake .#the-hostname'
      nixosConfigurations = {
        jnix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/jnix/configuration.nix
          ];
        };
        lenovo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/lenovo/configuration.nix
          ];
        };
      };

      # Available through 'home-manager --flake .#janmejay@jnix'
      homeConfigurations = {
        "janmejay@jnix" = home-mgr-cfg;
        "janmejay@lenovo" = home-mgr-cfg;
      };
   };
}