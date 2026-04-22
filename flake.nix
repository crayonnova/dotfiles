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
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      mkHome =
        { system
        , modules
        ,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home.nix ] ++ modules;
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
