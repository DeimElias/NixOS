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
          rev = "4faa83e4b9306750fc8de64b38c6f53c57862db8";
          sha256 = "sha256-ruhEqXnWRCYdX5mRczpY3rj1DTdxyY3BoN9pdlDOKrE=";
        };
        installPhase = ''
          	mkdir -p $out
              		cp -r ./* $out/
                    	'';
      };
    in

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
          confirm-close-surface = false;
          custom-shader = "${cursor_shaders}/ripple_cursor.glsl";
        };
      };
    };

}
