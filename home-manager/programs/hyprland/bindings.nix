{ config, ...}: {
  wayland.windowManager.hyprland.settings = {
    bind =  [
        # Window management
        "SUPER, G, fullscreen,"
        "SUPER, Q, killactive,"
        "SUPER, M, exit,"
        "SUPER, F, exec, thunar"
        "SUPER, W, exec, rofi -show combi -combi-modi \"window,drun\""
        "SUPER, L, exec, \"${config.programs.hyprlock.package}/bin/hyprlock\""
        "SUPER, J, togglesplit, # dwindle"
  
        # Move active window with SUPER+SHIFT+arrow
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"
  
        # Screenshot
        "SUPER SHIFT, P, exec, \"${config.xdg.configHome}/rofi/screenshot.sh\""
  
        # Functional keys
        ",XF86AudioMicMute, exec, pamixer --default-source -t"
        ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        ",XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ",XF86AudioMute, exec, pamixer -t"
        ",XF86AudioLowerVolume, exec, pamixer -d 10"
        ",XF86AudioRaiseVolume, exec, pamixer -i 10"
  
        # Floating workspace window cycling
        "SUPER, Tab, cyclenext,"
        "SUPER, Tab, bringactivetotop,"
  
        # Move focus with arrows
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
  
        # Switch workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"
  
        # Move window to workspace
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
  
        # Scroll workspaces
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
      ];
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        "ALT, mouse:272, resizewindow"
      ];
  };
}

