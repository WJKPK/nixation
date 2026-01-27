{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    # Environment variables
    # https://wiki.hyprland.org/Configuring/Variables/#input
    input = lib.mkDefault {
      kb_layout = "pl";
      # kb_variant =
      # kb_model =
      kb_options = "compose:caps";
      # kb_rules =

      follow_mouse = 0;

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
        natural_scroll = false;
      };
    };
  };
}
