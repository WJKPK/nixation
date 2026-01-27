{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.utilities.kicad;
  # There can be some crashes - workaround: https://github.com/NixOS/nixpkgs/issues/366299#issuecomment-2613745185
  wrapNixGL = pkgs.callPackage (import ./../wrap-nix-gl.nix) {};
  kicad-dark = pkgs.symlinkJoin {
    name = "kicad-dark";
    paths = [pkgs.stable.kicad];
    buildInputs = [pkgs.makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/kicad \
        --set GTK_THEME Arc-Dark
    '';
  };

  wrappedKicad = wrapNixGL kicad-dark;
  kicad =
    if config.application.wrap-gl
    then wrappedKicad
    else kicad-dark;

  kicadThemes = pkgs.fetchFromGitHub {
    owner = "pointhi";
    repo = "kicad-color-schemes";
    rev = "2021-12-05";
    hash = "sha256-PYgFOyK5MyDE1vTkz5jGnPWAz0pwo6Khu91ANgJ2OO4=";
  };
in {
  options.utilities.kicad = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable KiCad.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kicad
      arc-theme
      stable.kikit
      stable.kicadAddons.kikit
    ];

    xdg.configFile."kicad/9.0/colors/behave-dark.json" = {
      source = "${kicadThemes}/behave-dark/behave-dark.json";
    };
  };
}
