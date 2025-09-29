{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "dunst"
      "dbus-update-activation-environment --systemd HYPRLAND_INSTANCE_SIGNATURE"
      "hyprctl setcursor Bibata-Modern-Classic 14"
      "systemctl --user start hyprpolkitagent"
      "wl-clip-persist --clipboard regular & clipse -listen"
    ];

    exec = [
      "hyprshade auto"
    ];
  };
}
