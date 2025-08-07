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
        obsl = os-cfg ./nixos/obsl/configuration.nix;
      };

      # Available through 'home-manager --flake .#janmejay@jnix'
      homeConfigurations = {
        "janmejay@jnix" = home-mgr-cfg;
        "janmejay@lenovo" = home-mgr-cfg;
        "janmejay@dell" = home-mgr-cfg;
        "janmejay@obsl" = home-mgr-cfg;
      };

      devShells."${system}" = {
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
            go_1_23
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
            go_1_23
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