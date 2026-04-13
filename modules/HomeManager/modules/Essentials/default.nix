{ self, inputs, ... }:
{
  flake.homeModules.homeEssentials =
    { pkgs, lib, ... }:
    {
      home.shell.enableNushellIntegration = true;
      home.stateVersion = "25.05";
      home.username = "chimuelo";
      home.homeDirectory = "/home/chimuelo";
      programs.home-manager.enable = true;
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
