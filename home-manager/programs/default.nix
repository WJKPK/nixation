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
    ./btop
    ./openscad
  ];
  nixos-os-pkgs = (lib.optionals isNixos [
    ./dunst
    ./hypr
    ./waybar
    ./hyprlock
    ./hyprshade
  ]);
in {
  imports = common-pkgs ++ (nixos-os-pkgs);
}
