{ nixgl, config, specialArgs, ... }:
let
  inherit (specialArgs) isNixos;
in {
  targets.genericLinux.enable = !isNixos;
  imports = [
    ./programs
    ./common.nix
  ];
  home = {
    username = "wkrupski";
    homeDirectory = "/home/wkrupski";
  };
  nixpkgs = {
    overlays = [
      nixgl.overlay
    ];
  };
}
