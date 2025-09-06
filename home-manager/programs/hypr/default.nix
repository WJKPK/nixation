{ pkgs, lib, config, osConfig, ... }:
let
  monitors = osConfig.monitors;
  monitor = lib.concatStrings (map (m: let
        resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
        position = "${toString m.x}x${toString m.y}";
        scale = "${toString m.scale}";
      in
        "monitor = ${m.name},${if m.enabled then "${resolution},${position},${scale}" else "disable"}\n"
      ) monitors);

    workspace = lib.concatStrings ( map (m:
        "\nworkspace = ${m.name},${m.workspace}"
      ) (lib.filter (m: m.enabled && m.workspace != null) monitors));
in {
  home.packages = with pkgs; [
    jq
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    xwayland.enable = true;
    extraConfig = ''
    ${monitor}
    ${workspace}
    monitor=Unknown-1,disable
    # Autostart
    exec-once = hyprctl setcursor Bibata-Modern-Classic 18
    exec-once = dunst
    exec-once = dbus-update-activation-environment --systemd HYPRLAND_INSTANCE_SIGNATURE
    exec-once = systemctl --user start hyprpolkitagent
    exec = hyprshade auto

    # Set en layout at startup

    general {
        allow_tearing = false
        gaps_in = 5
        gaps_out = 5
        border_size = 2
        layout = dwindle
    }

    cursor {
        no_hardware_cursors = true
    }
    input {
        kb_layout=pl
    }

    decoration {
        rounding = 0
    
        active_opacity = 0.99 
        inactive_opacity = 0.85
    
        blur {
            enabled = yes
            size = 5
            passes = 4
            ignore_opacity = true
            new_optimizations = true
            xray = false
            noise = 0.0
            popups = true
        }
    
        dim_inactive = false
        dim_strength = 0.05
    }

    animations {
        enabled = no
    }

    dwindle {
        pseudotile = yes
        preserve_split = yes
    }

    gestures {
        workspace_swipe = false
    }

    misc {
      disable_hyprland_logo = yes
      animate_manual_resizes = yes
      animate_mouse_windowdragging = yes
      mouse_move_enables_dpms = true
      key_press_enables_dpms = true
    }
    xwayland {
        force_zero_scaling = true
    }
    # Example windowrule v1
    # windowrule = float, ^(kitty)$
    # Example windowrule v2
    # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

    $mainMod = SUPER
    bind = $mainMod, G, fullscreen,

    bind = $mainMod, Q, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, F, exec, thunar
    bind = $mainMod, V, togglefloating,
#    bind = $mainMod, w, exec, rofi -show combi -combi-modi "window:jumper,drun"
    bind = $mainMod, w, exec, rofi -show combi -combi-modi "window,drun"

    bind = $mainMod, L, exec, "${config.programs.hyprlock.package}/bin/hyprlock"
    bind = $mainMod, J, togglesplit, # dwindle

    bind = SUPER SHIFT, H, movewindow, l
    bind = SUPER SHIFT, L, movewindow, r
    bind = SUPER SHIFT, K, movewindow, u
    bind = SUPER SHIFT, J, movewindow, d 


    bind = SUPER SHIFT, P, exec, "${config.xdg.configHome}/rofi/screenshot.sh"

    # Functional keybinds
    bind =,XF86AudioMicMute,exec,pamixer --default-source -t
    bind =,XF86MonBrightnessDown,exec,brightnessctl s 5%-
    bind =,XF86MonBrightnessUp,exec,brightnessctl s +5%
    bind =,XF86AudioMute,exec,pamixer -t
    bind =,XF86AudioLowerVolume,exec,pamixer -d 10
    bind =,XF86AudioRaiseVolume,exec,pamixer -i 10

    # to switch between windows in a floating workspace
    bind = SUPER,Tab,cyclenext,
    bind = SUPER,Tab,bringactivetotop,

    # Move focus with mainMod + arrow keys
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Scroll through existing workspaces with mainMod + scroll
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
    bindm = ALT, mouse:272, resizewindow
    '';
  };
}

