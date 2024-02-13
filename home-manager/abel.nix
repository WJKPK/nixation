{ inputs, ...}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./programs/wayland-conf.nix
    ./common.nix
    ./own_credentials.nix
    ./wallpapers
  ];
  monitors = [
    {
      name = "eDP-1";
      width = 2560;
      height = 1440;
      x = 0;
      workspace = "1";
      enabled = true;
      primary = true;
    }
  ];
}
