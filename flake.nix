{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { nixpkgs, home-manager, hyprland, stylix, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations."nozzdesk" = nixpkgs.lib.nixosSystem {
      modules = [
        ./systems/nozzdesk/configuration.nix
      ];
    };
    homeConfigurations."noah" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        hyprland.homeManagerModules.default
        stylix.homeManagerModules.stylix
        {
          home.username = "noah";
          home.homeDirectory = "/home/noah";
          home.stateVersion = "22.11";
          programs.home-manager.enable = true;
        }
        (import ./users/noah)
      ];
    };
    extraSpecialArgs = { inherit stylix; };
  };
}
