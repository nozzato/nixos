{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager.url = github:nix-community/home-manager;
    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    ...
  } @ inputs: let
    # Snippet from https://github.com/Misterio77/nix-config/blob/main/flake.nix
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;

    nixosConfigurations = {
      nozdesk = lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./system
          ./system/client
          ./system/nozdesk
        ];
      };
    };

    homeConfigurations = {
      "noah@nozdesk" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./home
          ./home/client
        ];
      };
    };
  };
}
