{
  pkgs,
  lib,
  ...
}: 
{
  imports = [
    ./autostart.nix
    ./bindings.nix
    ./envs.nix
    ./input.nix
    ./looknfeel.nix
    ./windows.nix
  ];
  wayland.windowManager.hyprland.settings = {
    # Default applications
    "$terminal" = lib.mkDefault "kitty";
    "$fileManager" = lib.mkDefault "thunar";
    "$browser" = lib.mkDefault "librewolf";
#    "$music" = lib.mkDefault "spotify";
    "$passwordManager" = lib.mkDefault "keepassxc";
    "$messenger" = lib.mkDefault "signal-desktop";
#    "$webapp" = lib.mkDefault "$browser --app";
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
  };
  services.hyprpolkitagent.enable = true;
}
