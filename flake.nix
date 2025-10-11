{
  description = "NixConfig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    sops-nix.url = "github:Mic92/sops-nix";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";

    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nixvim, sops-nix, ... }@inputs:
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
        modules = [ cfg-file ];
        specialArgs = { inherit inputs; };
      };

      home-mgr-cfg-d = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsDarwin;
        extraSpecialArgs = { inherit inputs nixvim; };
        modules = [ ./home-manager/darwin.nix ];
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
        "janmejay@jpl" = home-mgr-cfg-darwin;
      };

      devShells."${linuxSystem}" = {
        amm = pkgs.mkShell {
          packages = [ pkgs.ammonite_2_13 ];
        };
        linux = pkgs.stdenv.mkDerivation {
          name = "dev-shell";

          nativeBuildInputs = with pkgs; [
            pkg-config
            ncurses
            flex
            bison
          ];

          shellHook = ''
            echo Src tarball: ${pkgs.linux.src}
          '';
        };
        fdb = pkgs.mkShell {
          name = "FoundationDB";

          packages = with pkgs; [
            cmake
            ninja
            mono
            jemalloc
            openssl
            lz4
          ];

          shellHook = ''
            echo FDB
          '';
        };
        plot = pkgs.mkShell {
          name = "plot";
          hardeningDisable = [ "all" ];
          packages = [
            (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
              pandas
              requests
              numpy
              seaborn
              matplotlib
            ]))
          ];
        };
        work = pkgs.mkShell {
          name = "work";
          hardeningDisable = [ "all" ];
          packages = with pkgs; [
            awscli2
            azure-cli
            kubectl
            kubectx
            minikube
            go_1_25
            delve
            clang
            k9s
            kubernetes-helm
            grpcurl
            gh
            yq
            graphqurl
            visualvm
            unzip
            evcxr
            rustc
            gradle
            openjdk
            protobuf
            lua54Packages.lua
            sqlite
            google-cloud-sdk
          ];
          shellHook = ''
            export KUBECONFIG=/home/janmejay/.kube/config
            dp_bin=$(pwd)/dataplane
            if [ -e $dp_bin ]; then
              echo "Found dataplane bin, adding to path"
              export PATH=$PATH:$(dirname $dp_bin)
            else
              echo "Found NO dataplane bin ($dp_bin)"
            fi
            exec /home/janmejay/.nix-profile/bin/zsh
          '';
          buildInputs = [
            pkgs.sbt
          ];
        };
        work_fhs = (pkgs.buildFHSEnv {
          name = "work_fhs";
          targetPkgs = pkgs: (with pkgs; [
            awscli2
            kubectl
            kubectx
            minikube
            go_1_25
            virtualenv
          ]);
          multiPkgs = pkgs: (with pkgs; [
            udev
            alsa-lib
          ]);
          runScript = "zsh";
        }).env;
      };
   };
}
