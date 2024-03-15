{ pkgs, inputs, specialArgs, ... }:
let
  inherit (specialArgs) isNixos;
in {
  targets.genericLinux.enable = !isNixos;
  imports = [
    ./programs
    ./common.nix
  ];
  home.packages = with pkgs; [
    libreoffice
  ];

  home = {
    username = "wkrupski";
    homeDirectory = "/home/wkrupski";
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
      inputs.nixgl.overlay
    ];
  };
}
