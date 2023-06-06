{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    nix-alien.url = "github:thiagokokada/nix-alien";
    stylix.url = "github:danth/stylix";

    check-battery.url = "path:bin/check-battery";
    dwa.url = "path:bin/dwa";
    grsync.url = "path:bin/grsync";
    rgb.url = "path:bin/rgb";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    nix-alien,
    stylix,
    check-battery,
    dwa,
    grsync,
    rgb,
    ... 
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    home-manager.useGlobalPkgs = true;

    nixosConfigurations."nozzdesk" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit self system; };

      modules = [
        ./system/headless
        ./system/headful
        ./system/nozzdesk
      ];
    };
    homeConfigurations."noah@nozzdesk" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit self system; };

      modules = [
        hyprland.homeManagerModules.default
        stylix.homeManagerModules.stylix

        ./home/headless
        ./home/headful
        ./home/nozzdesk
      ];
    };

    nixosConfigurations."nozzlap" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit self system; };

      modules = [
        ./system/headless
        ./system/headful
        ./system/nozzlap
      ];
    };
    homeConfigurations."noah@nozzlap" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit self system; };

      modules = [
        hyprland.homeManagerModules.default
        stylix.homeManagerModules.stylix

        ./home/headless
        ./home/headful
        ./home/nozzlap
      ];
    };
  };
}
