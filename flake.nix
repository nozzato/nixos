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
    nixosConfigurations.nozzdesk = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit self system; };

      modules = [
        ./system
      ];
    };
    homeConfigurations.noah = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit self system; };

      modules = [
        hyprland.homeManagerModules.default
        stylix.homeManagerModules.stylix

        ./home
      ];
    };
  };
}
