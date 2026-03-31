{
  description = "My Nixos configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgss.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen.url = "github:youwen5/zen-browser-flake";
    zen.inputs.nixpkgs.follows = "nixpkgs";
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      zen,
      winapps,
      shell,
      nixpkgss,
      ...
    }:
    let
      #Define system
      system = "x86_64-linux";

      #Overlays stuff searchs recursively for every "overlay.nix" file and imports it
      isOverlay = file: (baseNameOf file) == "overlay.nix";
      findOverlays = (
        map (overlay: import overlay) (
          builtins.filter isOverlay (nixpkgs.lib.filesystem.listFilesRecursive ./.)
        )
      );

      importOverlays =
        { ... }:
        {
          nixpkgs.overlays = findOverlays;
        };

      #Stable-branch for some packages
      stable = import nixpkgss { inherit system; };
    in
    {
      nixosConfigurations.chimuelo = nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
          inherit stable system inputs;
        };
        modules = [
          #Ensure overlays are available to NixOS configurations
          importOverlays
          ./configuration.nix
          ./hardware-configs/chimuelo.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.chimuelo = {
              imports = [
                #Ensure overlays are available to HomeManager
                importOverlays
                ./home.nix
                shell.homeManagerModules.default
              ];
            };
            home-manager.extraSpecialArgs = { inherit zen stable shell; };
          }

          (
            {
              pkgs,
              system ? pkgs.system,
              ...
            }:
            {
              environment.systemPackages = [
                winapps.packages."${system}".winapps
              ];
            }
          )
        ];
      };
    };
}
