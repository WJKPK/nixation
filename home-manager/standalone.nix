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
  monitors = [
    {
      name = "HDMI-1";
      width = 1920;
      height = 1080;
      primary = true;
      enabled = false;
    }
  ];
  nixpkgs = {
    overlays = [
      nixgl.overlay
    ];
  };
}
