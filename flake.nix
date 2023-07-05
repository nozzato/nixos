{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    nix-alien,
    nix-index-database,
    stylix,
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
        nix-index-database.hmModules.nix-index
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
        nix-index-database.hmModules.nix-index
        stylix.homeManagerModules.stylix

        ./home/headless
        ./home/headful
        ./home/nozzlap
      ];
    };
  };
}
