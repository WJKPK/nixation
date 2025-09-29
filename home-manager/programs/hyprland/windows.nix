{
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      "suppressevent maximize, class:.*"

      # Settings management
      "float, class:^(org.pulseaudio.pavucontrol)$"
      "size 50% 50%, class:^(org.pulseaudio.pavucontrol)$"

      # Float Steam
      "float, class:^(steam)$"

      # Just dash of transparency
      "opacity 0.97 0.9, class:.*"
      # Normal chrome Youtube tabs
      "opacity 1 1, class:^(librewolf|firefox)$, title:.*Youtube.*"
      "opacity 1 0.97, class:^(librewolf|firefox)$"
      "opacity 1 1, class:^(steam)$"

      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
    ];

    layerrule = [
      "blur,rofi"
      "noanim,rofi"
      "blur,waybar"
    ];
  };
}
