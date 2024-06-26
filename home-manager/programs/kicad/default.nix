{pkgs, ...}: let
  kicad-dark = pkgs.stable.kicad.overrideAttrs (prevAttrs: {
    nativeBuildInputs = (prevAttrs.nativeBuildInputs or []) ++ [ pkgs.makeBinaryWrapper ];

    postInstall = (prevAttrs.postInstall or "") + ''
      wrapProgram $out/bin/kicad --set GTK_THEME Arc-Dark
    '';
  });
  kicadThemes = pkgs.fetchFromGitHub {
    owner = "pointhi";
    repo = "kicad-color-schemes";
    rev = "2021-12-05";
    hash = "sha256-PYgFOyK5MyDE1vTkz5jGnPWAz0pwo6Khu91ANgJ2OO4=";
  };
in {
  home.packages = [
    kicad-dark 
  ];

  # Add behave dark theme
  xdg.configFile."kicad/8.0/colors/behave-dark.json" = {
    source = "${kicadThemes}/behave-dark/behave-dark.json";
  };

}

