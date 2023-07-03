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

    dwa = {
      url = "path:bin/dwa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grsync = {
      url = "path:bin/grsync";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rgb = {
      url = "path:bin/rgb";
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
