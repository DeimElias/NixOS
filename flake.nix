{
  description = "My Nixos configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgss.url = "github:NixOS/nixpkgs/nixos-25.05";
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
      system = "x86_64-linux";
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
      stable = import nixpkgss { inherit system; };
    in
    {
      nixosConfigurations.chimuelo = nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
          inherit stable system inputs;
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
            home-manager.extraSpecialArgs = { inherit zen stable; };
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
