{ self, inputs, ... }:
{
  flake.homeModules.ghostty =
    { pkgs, lib, ... }:
    let
      cursor_shaders = pkgs.stdenv.mkDerivation {
        pname = "ghostty-cursor-shaders";
        version = "1.0";
        src = pkgs.fetchFromGitHub {
          owner = "sahaj-b";
          repo = "ghostty-cursor-shaders";
          rev = "9ad9158a93c0de0c045e1c6b27df37da698bc8af";
          hash = "sha256-TnoQvptwjs6P5/JfJO1CR3yhCfCcaw5wvPr5oEhn4Ho=";
        };
        installPhase = ''
          	mkdir -p $out
            cp -r ./ghostty/* $out/
        '';
      };
    in

    {
      stylix.targets.ghostty.enable = false;
      programs.ghostty = {
        enable = true;
        settings = {
          theme = "TokyoNight Storm";
          font-size = 16;
          gtk-tabs-location = "hidden";
          clipboard-read = "allow";
          clipboard-write = "allow";
          window-padding-x = "10";
          window-padding-y = "12,0";
          font-family = "FiraCode Nerd Font Mono";
          background-opacity = 0.78;
          confirm-close-surface = false;
          custom-shader = "${cursor_shaders}/cursor_warp.glsl";
        };
      };
    };

}
