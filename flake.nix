{
  description = "Nixation";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nix-colors.url = "github:misterio77/nix-colors";

    nixos-hardware.url = "github:NixOs/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:guibou/nixGL";
    catppuccin.url = "github:catppuccin/nix";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lavix.url = "github:WJKPK/lavix";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in {
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );
    overlays = import ./overlays { inherit inputs; };
      # NixOS configuration entrypoint
      # Available through 'sudo nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        veles = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/veles/configuration.nix
          ];
        };
        perun = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/perun/configuration.nix
          ];
        };
        rod = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/rod/configuration.nix
          ];
        };
      };

      # HomeManager configuration entrypoint
      # Available through 'home-manager switch --flake .#config-name"
      homeConfigurations = {
        "standalone" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs;};
          modules = [
            ./home-manager/standalone.nix
          ];
        };
        "minimal-nvim" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs;};
          modules = [
            ./home-manager/minimal-nvim.nix
          ];
        };
      };
    };
}
