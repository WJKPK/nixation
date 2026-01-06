{
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      # Suppress maximize events globally
      "suppress_event maximize, match:class .*"

      # Settings management
      "float on, match:class ^(org.pulseaudio.pavucontrol)$"
      "size 50% 50%, match:class ^(org.pulseaudio.pavucontrol)$"

      "float on, match:class ^(.*blueman-manager.*)$"
      "size 50% 50%, match:class ^(.*blueman-manager.*)$"

      # Float Steam
      "float on, match:class ^(steam)$"

      # Global slight transparency
      "opacity 0.97 0.9, match:class .*"

      # Normal Firefox / LibreWolf YouTube tabs
      "opacity 1 1, match:class ^(librewolf|firefox)$, match:title .*Youtube.*"

      # Firefox / LibreWolf default opacity
      "opacity 1 0.97, match:class ^(librewolf|firefox)$"

      # Steam always opaque
      "opacity 1 1, match:class ^(steam)$"

      # Fix dragging issues with XWayland ghost windows
      "no_focus on, match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false"
    ];

    layerrule = [
      "blur on, match:namespace rofi"
      "no_anim on, match:namespace rofi"
      "blur on, match:namespace waybar"
    ];
  };
}
