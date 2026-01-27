{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop.addons.dunst;
in {
  options.desktop.addons.dunst = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable dunst notifications.";
    };
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          frame_color = "#${config.colorScheme.palette.base0F}";
          separator_color = "#${config.colorScheme.palette.base0E}";
          width = 320;
          height = 380;
          offset = "0x15";
          font = "JetBrainsMono Nerd Font";
          corner_radius = 0;
          origin = "top-center";
          notification_limit = 3;
          idle_threshold = 120;
          ignore_newline = "no";
          mouse_left_click = "close_current";
          mouse_right_click = "close_all";
          sticky_history = "yes";
          history_length = 20;
          show_age_threshold = 60;
          ellipsize = "middle";
          padding = 10;
          always_run_script = true;
          frame_width = 2;
          transparency = 10;
          progress_bar = true;
          progress_bar_frame_width = 0;
          highlight = "#${config.colorScheme.palette.base0E}";
        };
        fullscreen_delay_everything.fullscreen = "delay";
        urgency_low = {
          background = "#${config.colorScheme.palette.base00}";
          foreground = "#${config.colorScheme.palette.base07}";
          timeout = 5;
        };
        urgency_normal = {
          background = "#${config.colorScheme.palette.base00}";
          foreground = "#${config.colorScheme.palette.base07}";
          timeout = 6;
        };
        urgency_critical = {
          background = "#${config.colorScheme.palette.base00}";
          foreground = "#${config.colorScheme.palette.base08}";
          frame_color = "#${config.colorScheme.palette.base05}";
          timeout = 0;
        };
      };
    };
  };
}
