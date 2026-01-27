{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop.environment.hyprland;
in {
  options.desktop.environment.hyprland = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Hyprland.";
    };
  };
  imports = [
    ./autostart.nix
    ./bindings.nix
    ./envs.nix
    ./input.nix
    ./looknfeel.nix
    ./windows.nix
  ];

  config = {
    home.packages = with pkgs;
      mkIf cfg.enable [
        pavucontrol
        satty
        hyprshot
        grim
        slurp
        wl-clipboard
        brightnessctl
        pamixer
      ];
    wayland.windowManager.hyprland.settings = {
      # Default applications                           };
      "$terminal" = lib.mkDefault "kitty";
      "$fileManager" = lib.mkDefault "thunar";
      "$browser" = lib.mkDefault "librewolf";
      # "$music" = lib.mkDefault "spotify";
      "$passwordManager" = lib.mkDefault "keepassxc";
      "$messenger" = lib.mkDefault "signal-desktop";
      # "$webapp" = lib.mkDefault "$browser --app";
    };
    wayland.windowManager.hyprland = {
      enable = cfg.enable;
      package = pkgs.hyprland;
    };
    services.hyprpolkitagent.enable = cfg.enable;
  };
}
