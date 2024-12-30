{ pkgs, outputs, inputs, specialArgs, ... }:
let
  inherit (specialArgs) isNixos;
in {
  targets.genericLinux.enable = !isNixos;
  imports = [
    ./programs
    ./common.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      inputs.nixgl.overlay
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        "electron-27.3.11" # logseq dep
      ];
    };
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

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
}
