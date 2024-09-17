{
  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      home-mgr-cfg = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager/home.nix
          ];
        };

      os-cfg = cfg-file : nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = { inherit inputs; };
          modules = [
            cfg-file
            sops-nix.nixosModules.sops
          ];
        };
    in {

      # build: 'nixos-rebuild --flake .#the-hostname'
      nixosConfigurations = {
        jnix = os-cfg ./nixos/jnix/configuration.nix;
        lenovo = os-cfg ./nixos/lenovo/configuration.nix;
        dell = os-cfg ./nixos/dell/configuration.nix;
      };

      # Available through 'home-manager --flake .#janmejay@jnix'
      homeConfigurations = {
        "janmejay@jnix" = home-mgr-cfg;
        "janmejay@lenovo" = home-mgr-cfg;
        "janmejay@dell" = home-mgr-cfg;
      };

      devShells."${system}" = {
        linux = pkgs.stdenv.mkDerivation {
          name = "dev-shell";

          nativeBuildInputs = [
            pkgs.pkg-config
            pkgs.ncurses
          ];

          shellHook = ''
            echo Src tarball: ${pkgs.linux.src}
          '';
        };
      };
   };
}