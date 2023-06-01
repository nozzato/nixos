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

    rgb-toggle.url = "path:bin/rgb-toggle";
    rsync-gnu.url = "path:bin/rsync-gnu";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, nix-alien, stylix, rgb-toggle, rsync-gnu, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.nozzdesk = nixpkgs.lib.nixosSystem {
      modules = [
        /etc/nixos/hardware-configuration.nix
        ./system/nozzdesk/configuration.nix
        ./system/nozzdesk/packages.nix
        ./system/security.nix
        ./system/xdg.nix
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
        ./home/packages.nix
        ./home/security.nix
        ./home/shell.nix
        ./home/theme.nix
        ./home/vim.nix
        ./home/xdg.nix
      ];
    };
  };
}
