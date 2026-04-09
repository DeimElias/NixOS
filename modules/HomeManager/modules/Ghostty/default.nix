{ self, inputs, ... }:
{
  flake.homeModules.ghostty =
    { pkgs, lib, ... }:
    {
      programs.ghostty = {
        enable = true;
        settings = {
          theme = "TokyoNight Storm";
          font-size = 13;
          gtk-tabs-location = "hidden";
          clipboard-read = "allow";
          clipboard-write = "allow";
          window-padding-x = "10";
          window-padding-y = "12,0";
          font-family = "FiraCode Nerd Font Mono";
          background-opacity = 0.78;
        };
      };
    };
}
