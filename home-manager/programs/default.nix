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
    ./kicad
    ./tmux-sessionizer
    ./yazi
  ];
  nixos-os-pkgs = (lib.optionals isNixos [
    ./dunst
    ./hypr
    ./waybar
    ./hyprlock
  ]);
in {
  imports = common-pkgs ++ (nixos-os-pkgs);
}
