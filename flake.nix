{
 description = "NixOS Config";

 inputs = {
   nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

   home-manager.url = "github:nix-community/home-manager";
   home-manager.inputs.nixpkgs.follows = "nixpkgs";

   hardware.url = "github:nixos/nixos-hardware";
 };

 outputs = { self, nixpkgs, home-manager, ... }@inputs: {

   # build: 'nixos-rebuild --flake .#the-hostname'
   nixosConfigurations = {
     jnix = nixpkgs.lib.nixosSystem {
       specialArgs = { inherit inputs; };
       modules = [
         ./nixos/configuration.nix
       ];
     };
   };

   # Available through 'home-manager --flake .#janmejay@jnix'
   homeConfigurations = {
     "janmejay@jnix" = home-manager.lib.homeManagerConfiguration {
       pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager wants 'pkgs'
       extraSpecialArgs = { inherit inputs; };
       modules = [
           ./home-manager/home.nix
       ];
     };
   };
 };
}