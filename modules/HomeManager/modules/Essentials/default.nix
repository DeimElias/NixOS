{ self, inputs, ... }:
{
  flake.homeModules.homeEssentials =
    { pkgs, lib, ... }:
    {
      home.shell.enableNushellIntegration = true;
      home.stateVersion = "25.05";
      programs.home-manager.enable = true;
      home.username = "chimuelo";
      home.homeDirectory = "/home/chimuelo";
      imports = [
        self.homeModules.tmux
        self.homeModules.shell
      ];
      home.packages = [
        pkgs.bat
        pkgs.fzf
        pkgs.btop
      ];
    };
}
