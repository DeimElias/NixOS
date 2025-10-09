final: prev: {
  cups-zj = final.stdenv.mkDerivation {
    pname = "cups-zj58-80";
    version = "2025-09-22";
    src = final.fetchFromGitHub {
      owner = "klirichek";
      repo = "zj-58";
      rev = "64743565df4379098b68a197d074c86617a8fc0a";
      sha256 = "sha256-4l9NRfp0hiPDC6dtFsq7jLf0Gn9tktGy6oZ4GHxSfbw=";
    };
    nativeBuildInputs = [
      final.cmake
      final.pkg-config
    ];
    buildInputs = [ final.cups ];
    installPhase = ''
      install -D ppd/zj80.ppd $out/share/cups/model/zjiang/zj80.ppd
      install -D ppd/zj58.ppd $out/share/cups/model/zjiang/zj58.ppd
      install -D rastertozj $out/lib/cups/filter/rastertozj
    '';
  };
}
