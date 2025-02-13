{pkgs, ...}:
let
  kicad-dark = pkgs.symlinkJoin {
    name = "kicad-dark";
    paths = [pkgs.stable.kicad];
    buildInputs = [pkgs.makeWrapper];
    # workaround for crashes: https://github.com/NixOS/nixpkgs/issues/366299#issuecomment-2613745185
    postBuild = ''
      wrapProgram $out/bin/kicad \
        --set GTK_THEME Arc-Dark \
        --set __GLX_VENDOR_LIBRARY_NAME mesa \
        --set __EGL_VENDOR_LIBRARY_FILENAMES ${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json
    '';
  };

  kicadThemes = pkgs.fetchFromGitHub {
    owner = "pointhi";
    repo = "kicad-color-schemes";
    rev = "2021-12-05";
    hash = "sha256-PYgFOyK5MyDE1vTkz5jGnPWAz0pwo6Khu91ANgJ2OO4=";
  };
in {
  home.packages = [kicad-dark];

  xdg.configFile."kicad/8.0/colors/behave-dark.json" = {
    source = "${kicadThemes}/behave-dark/behave-dark.json";
  };
}
