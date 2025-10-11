{
  description = "NixConfig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew"; 

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, nix-darwin, nix-homebrew, home-manager, nixvim, sops-nix, ... }@inputs:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      pkgsl = nixpkgs.legacyPackages.${linuxSystem};
      pkgsd = nixpkgs.legacyPackages.${darwinSystem};

      home-mgr-cfg-l = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsl;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home-manager/home.nix ];
      };

      linux-cfg = cfg-file : nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          specialArgs = { inherit inputs; };
          modules = [ cfg-file sops-nix.nixosModules.sops ];
        };

      darwin-cfg = cfg-file: nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        modules = [ 
	  cfg-file  
	  nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
	      enable = true;
	      enableRosetta = true;
	      user = "janmejay";
	    };
          }
	];
        specialArgs = { inherit inputs; };
      };

      home-mgr-cfg-d = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsd;
        extraSpecialArgs = { inherit inputs nixvim; };
        modules = [ 
	  ./home-manager/darwin.nix 
	  nixvim.homeModules.nixvim
	];
      };
    in {

      # build: 'nixos-rebuild --flake .#the-hostname'
      nixosConfigurations = {
        jnix = linux-cfg ./nixos/jnix/configuration.nix;
        lenovo = linux-cfg ./nixos/lenovo/configuration.nix;
        dell = linux-cfg ./nixos/dell/configuration.nix;
        obsl = linux-cfg ./nixos/obsl/configuration.nix;
      };

      darwinConfigurations = {
        jpl = darwin-cfg ./darwin/jpl.nix;
      };	

      # Available through 'home-manager --flake .#janmejay@jnix'
      homeConfigurations = {
        "janmejay@jnix" = home-mgr-cfg-l;
        "janmejay@lenovo" = home-mgr-cfg-l;
        "janmejay@dell" = home-mgr-cfg-l;
        "janmejay@obsl" = home-mgr-cfg-l;
        "janmejay@jpl" = home-mgr-cfg-d;
      };
      
     #  let 
     #    supportedSystems = [ linuxSystem darwinSystem ];

     #    forAllSystems = f: builtins.listToAttrs (map (system: { name = system; value = f system; }) supportedSystems);
     #    
     #     mkDevShell = pkgs: pkgs.mkShell {
     #      name = "dev-shell";
     #      packages = with pkgs; [
     #        git
     #        jq
     #        tmux
     #        # ...add any cross-platform packages here...
     #      ];
     #      shellHook = ''
     #        echo "Welcome to dev-shell for ${pkgs.system}"
     #      '';
     #    };
     #  in {
     #    devShells = forAllSystems (system: mkDevShell (nixpkgs.legacyPackages.${system}));
     #    # ...other outputs...
     #  };


   };
}
