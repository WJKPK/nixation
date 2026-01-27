{
  lib,
  osConfig ? {},
  ...
}: let
  monitors = osConfig.monitors;
  primaryScale = (lib.findFirst (m: m.primary) {scale = 1.0;} monitors).scale;
  hasNvidiaDrivers = osConfig.nvidiaManagement.driver.enable;
  nvidiaEnv = [
    "NVD_BACKEND,direct"
    "LIBVA_DRIVER_NAME,nvidia"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
  ];
in {
  wayland.windowManager.hyprland.settings = {
    # Environment variables
    env =
      (lib.optionals hasNvidiaDrivers nvidiaEnv)
      ++ [
        "GDK_SCALE,${toString primaryScale}"

        # Force all apps to use Wayland
        "GDK_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland"
        "QT_STYLE_OVERRIDE,kvantum"
        "SDL_VIDEODRIVER,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "OZONE_PLATFORM,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"

        # Make .desktop files available for rofi
        "XDG_DATA_DIRS,$XDG_DATA_DIRS:$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share"

        "EDITOR,nvim"
      ];

    xwayland = {
      force_zero_scaling = true;
    };

    # Don't show update on first launch
    ecosystem = {
      no_update_news = true;
    };
  };
}
