{ nixgl, specialArgs, ... }:
let
  inherit (specialArgs) isNixos;
in {
  targets.genericLinux.enable = !isNixos;
  imports = [
    ./programs
    ./common.nix
  ];
  home = {
    username = "kruppenfield";
    homeDirectory = "/home/kruppenfield";
  };
  nixpkgs = {
    overlays = [
      nixgl.overlay
    ];
  };
}
