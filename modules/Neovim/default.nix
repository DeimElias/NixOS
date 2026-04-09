{ self, inputs, ... }:
{
  flake.overlays.default = (import ./_neovim/default.nix);

  perSystem =
    { system, pkgs, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
        ];
      };
      packages.neovim = pkgs.myNeovim;
      packages.nvim = pkgs.myNeovim;
      packages.vim = pkgs.myNeovim;
      packages.vi = pkgs.myNeovim;
    };

}
