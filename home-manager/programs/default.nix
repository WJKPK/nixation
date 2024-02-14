{ lib, specialArgs, ...}:
let
  inherit (specialArgs) isNixos;
  common-pkgs = [
    ./neovim
    ./kitty
    ./zsh
    ./git
    ./direnv
    ./rofi
  ];
  nixos-os-pkgs = (lib.optionals isNixos [
    ./dunst
    ./hypr
    ./waybar
    ./swaylock
  ]);
in {
  imports = common-pkgs ++ (nixos-os-pkgs);
}
