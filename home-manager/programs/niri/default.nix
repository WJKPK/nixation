{
  pkgs,
  lib,
  color-scheme,
  osConfig ? null,
  config,
  ...
}:
with lib; let
  cfg = config.desktop.environment.niri;
  hasOsConfig = builtins.isAttrs osConfig;
  monitors =
    if hasOsConfig && osConfig ? monitors
    then osConfig.monitors
    else [];
  activeBorder = lib.strings.removePrefix "#" color-scheme.palette.base0D;
  inactiveBorder = lib.strings.removePrefix "#" color-scheme.palette.base09;
  outputs = lib.concatStrings (map (
    m: let
      resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
      scale = "${toString m.scale}";
    in "output \"${m.name}\" {\n    mode \"${resolution}\"\n    scale ${scale}\n}\n"
  ) (lib.filter (m: m.enabled) monitors));
in {
  options.desktop.environment.niri = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Niri.";
    };
    exportSessionDesktopEntry = mkOption {
      type = types.bool;
      default = false;
      description = "Install a user-local niri wayland session desktop file.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.niri];
    home.file = mkIf cfg.exportSessionDesktopEntry {
      ".local/share/wayland-sessions/niri.desktop".text = ''
        [Desktop Entry]
        Name=Niri
        Comment=Scrollable-tiling Wayland compositor
        Exec=${lib.getExe' pkgs.niri "niri-session"}
        Type=Application
        DesktopNames=niri
      '';
    };
    xdg.configFile."niri/config.kdl".text = ''
      ${outputs}

      input {
          keyboard {
              repeat-delay 300
              repeat-rate 80
              xkb {
                  layout "pl"
                  options "compose:caps"
              }
          }

          touchpad {
              tap
              natural-scroll
              accel-speed 0.2
              accel-profile "adaptive"
              scroll-method "two-finger"
              disabled-on-external-mouse
          }

          trackpoint {
              accel-speed 0.25
              accel-profile "adaptive"
          }

          warp-mouse-to-focus
          focus-follows-mouse max-scroll-amount="0%"
      }

      layout {
          background-color "transparent"
          gaps 5

          focus-ring {
              width 2
              active-color "#${activeBorder}"
              inactive-color "#${inactiveBorder}"
          }

          shadow {
              off
          }
      }

      hotkey-overlay {
          skip-at-startup
      }

      prefer-no-csd

      window-rule {
          match app-id=r#"librewolf$"#
          opacity 0.97
      }

      window-rule {
          match app-id=r#"^org\.keepassxc\.KeePassXC$"#
          block-out-from "screen-capture"
      }

      window-rule {
          geometry-corner-radius 6
          clip-to-geometry true
      }

      // Set the overview wallpaper on the backdrop.
      layer-rule {
        match namespace="^noctalia-overview*"
        place-within-backdrop true
      }

      binds {
          Mod+Shift+Slash { show-hotkey-overlay; }

          Mod+T { spawn "kitty"; }
          Mod+W { spawn "sh" "-c" "pkill rofi || rofi -show combi -combi-modi window,drun"; }
          Super+Shift+L { spawn-sh "noctalia-shell ipc call lockScreen lock"; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
          XF86AudioMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
          XF86AudioMicMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

          XF86MonBrightnessUp allow-when-locked=true { spawn-sh "brightnessctl s +5%"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn-sh "brightnessctl s 5%-"; }

          Mod+O { toggle-overview; }

          Mod+Q { close-window; }

          Mod+Left  { focus-column-left; }
          Mod+Down  { focus-window-down; }
          Mod+Up    { focus-window-up; }
          Mod+Right { focus-column-right; }
          Mod+H     { focus-column-left; }
          Mod+J     { focus-window-down; }
          Mod+K     { focus-window-up; }
          Mod+L     { focus-column-right; }

          Mod+Ctrl+Left  { move-column-left; }
          Mod+Ctrl+Down  { move-window-down; }
          Mod+Ctrl+Up    { move-window-up; }
          Mod+Ctrl+Right { move-column-right; }
          Mod+Ctrl+H     { move-column-left; }
          Mod+Ctrl+J     { move-window-down; }
          Mod+Ctrl+K     { move-window-up; }
          Mod+Ctrl+L     { move-column-right; }

          Mod+Home { focus-column-first; }
          Mod+End  { focus-column-last; }
          Mod+Shift+Home { move-column-to-first; }
          Mod+Shift+End  { move-column-to-last; }

          Mod+Ctrl+Shift+Page_Down { move-column-to-workspace-down; }
          Mod+Ctrl+Shift+Page_Up   { move-column-to-workspace-up; }
          Mod+Ctrl+Shift+U         { move-column-to-workspace-down; }
          Mod+Ctrl+Shift+I         { move-column-to-workspace-up; }

          Mod+Shift+Page_Down { move-workspace-down; }
          Mod+Shift+Page_Up   { move-workspace-up; }
          Mod+Shift+U         { move-workspace-down; }
          Mod+Shift+I         { move-workspace-up; }

          Mod+Page_Down      { focus-workspace-down; }
          Mod+Page_Up        { focus-workspace-up; }
          Mod+U              { focus-workspace-down; }
          Mod+I              { focus-workspace-up; }

          Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
          Mod+Shift+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Shift+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

          Mod+WheelScrollRight      { focus-column-right; }
          Mod+WheelScrollLeft       { focus-column-left; }
          Mod+Shift+WheelScrollRight { move-column-right; }
          Mod+Shift+WheelScrollLeft  { move-column-left; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+Shift+3 { move-column-to-workspace 3; }
          Mod+Shift+4 { move-column-to-workspace 4; }
          Mod+Shift+5 { move-column-to-workspace 5; }
          Mod+Shift+6 { move-column-to-workspace 6; }
          Mod+Shift+7 { move-column-to-workspace 7; }
          Mod+Shift+8 { move-column-to-workspace 8; }
          Mod+Shift+9 { move-column-to-workspace 9; }

          Mod+Tab { focus-workspace-previous; }

          Mod+BracketLeft  { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }

          Mod+Comma  { consume-window-into-column; }
          Mod+Period { expel-window-from-column; }

          Mod+R { switch-preset-column-width; }
          Mod+Shift+R { switch-preset-window-height; }
          Mod+Ctrl+R  { reset-window-height; }

          Mod+F       { maximize-column; }
          Mod+Shift+F { fullscreen-window; }
          Mod+Ctrl+F  { expand-column-to-available-width; }

          Mod+C { center-column; }
          Mod+Shift+C { center-visible-columns; }

          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }

          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }

          Mod+V       { toggle-window-floating; }
          Mod+Shift+V { switch-focus-between-floating-and-tiling; }

          Print      { screenshot; }
          Shift+Print { screenshot-screen; }
          Alt+Print  { screenshot-window; }

          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

          Mod+Shift+E { quit; }
          Shift+Alt+Delete { quit; }

          Mod+Shift+P { power-off-monitors; }
      }

      spawn-at-startup "${config.programs.noctalia-shell.package}/bin/noctalia-shell"

      cursor {
          xcursor-theme "Bibata-Modern-Ice"
          xcursor-size 20
          hide-when-typing
          hide-after-inactive-ms 10000
      }
      overview {
          workspace-shadow {
              off
          }
      }
      xwayland-satellite {
          path "xwayland-satellite"
      }
      gestures {
          hot-corners {
              off
          }
      }

      debug {
        honor-xdg-activation-with-invalid-serial
      }
    '';
  };
}
