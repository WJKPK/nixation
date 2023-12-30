{ pkgs, ... }:
let
  image = builtins.fetchurl {
      url = "https://images4.alphacoders.com/130/1301526.png";
      sha256 = "0m2ilvs8rbyfw999lf7540cdx993mqq2rqw79z4dq22bfm0mnjfc";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
    sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm Background.jpg
    cp -r ${image} $out/Background.jpg
    echo "ThemeColor=#303446" >> $out/theme.conf
   '';
}
