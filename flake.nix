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
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, nix-alien, stylix, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.nozzdesk = nixpkgs.lib.nixosSystem {
      modules = [
        stylix.nixosModules.stylix

        /etc/nixos/hardware-configuration.nix
        ./system/nozzdesk/configuration.nix
        ./system/nozzdesk/packages.nix
        ./system/security.nix
        ./system/theme.nix
        ./system/xdg.nix
        ./shared/theme.nix
      ];
    };
    homeConfigurations.noah = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit self system; };

      modules = [
        hyprland.homeManagerModules.default
        stylix.homeManagerModules.stylix

        ./home/home.nix
        ./home/audio.nix
        ./home/desktop.nix
        ./home/git.nix
        ./home/neovim.nix
        ./home/packages.nix
        ./home/security.nix
        ./home/shell.nix
        ./home/theme.nix
        ./home/xdg.nix
        ./shared/theme.nix
      ];
    };
  };
}
