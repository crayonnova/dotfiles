{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lightpanda = {
      # Local scaffold for now; switch to "github:crayonnova/lightpanda-nix" after pushing.
      url = "path:/home/nova/lightpanda-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      mkHome =
        {
          system,
          modules,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ inputs.lightpanda.overlays.default ];
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "electron-39.8.10"
                "pnpm-10.29.2"
              ];
            };
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home.nix
            inputs.lightpanda.homeModules.default
          ]
          ++ modules;
        };
    in
    {
      homeConfigurations = {
        "crayon@nixos" = mkHome {
          system = "x86_64-linux";
          modules = [
            ./users/crayon.nix
            ./profiles/desktop.nix
          ];
        };

        "nova@nixos" = mkHome {
          system = "x86_64-linux";
          modules = [
            ./users/nova.nix
            ./profiles/desktop.nix
          ];
        };

        "kaungminkhant@DESKTOP-JA8S7GL" = mkHome {
          system = "x86_64-linux";
          modules = [
            ./users/kaungminkhant.nix
            ./profiles/desktop.nix
          ];
        };

        "crayon@nixie" = mkHome {
          system = "x86_64-linux";
          modules = [
            ./users/crayon.nix
            ./profiles/desktop.nix
          ];
        };

        "crayon@nixoswsl" = mkHome {
          system = "x86_64-linux";
          modules = [
            ./users/crayon.nix
            ./profiles/cli-dev.nix
          ];
        };

        "vscode@codespaces" = mkHome {
          system = "x86_64-linux";
          modules = [
            ./users/vscode.nix
            ./profiles/codespace.nix
          ];
        };
      };
    };
}
