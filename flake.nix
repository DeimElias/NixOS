{
  description = "My Nixos configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    };
    cli = {
      url = "github:caelestia-dots/cli";
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
      ...
    }:
    let
      findOverlays = file: (builtins.baseNameOf file) == "overlay.nix";
      obtainOverlays = (
        map (overlay: import overlay) (
          builtins.filter findOverlays (nixpkgs.lib.filesystem.listFilesRecursive ./.)
        )
      );
      pkgsWithOverlays =
        { ... }:
        {
          nixpkgs.overlays = obtainOverlays;
        };
    in
    {
      nixosConfigurations.chimuelo = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs system;
        };
        modules = [
          home-manager.nixosModules.home-manager
          pkgsWithOverlays
          ./configuration.nix
          {
            home-manager.useUserPackages = true;
            home-manager.users.chimuelo = {
              imports = [
                ./home.nix
                shell.homeManagerModules.default
                pkgsWithOverlays
              ];
            };
            home-manager.extraSpecialArgs = { inherit zen; };
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
