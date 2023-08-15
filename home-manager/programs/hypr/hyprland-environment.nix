{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
#    __GL_VRR_ALLOWED="1";
#    WLR_NO_HARDWARE_CURSORS = "1";
#    WLR_RENDERER_ALLOW_SOFTWARE = "1";
#    CLUTTER_BACKEND = "wayland";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    };
  };
}
