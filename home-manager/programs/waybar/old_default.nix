{ config, ... }: {

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    style = ''
      * {
        border: 1px;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12pt;
        min-height: 24px;
      }
      .modules-right,
      .modules-center,
      .modules-left {
        background-color: #${config.colorScheme.palette.base00};
        border-radius: 0px;
        border-style: solid;
        border-width: 2px;
        opacity: 0.75;
      }
      .modules-right,
      .modules-left {
        border-color: #${config.colorScheme.palette.base05};
      }
      .modules-right {
        margin: 2px 5px 2px 2px;
      }
      .modules-center {
        margin: 2px 0 2px 0;
        border-color: #${config.colorScheme.palette.base0F};
      }
      .modules-left {
        margin: 2px 0px 2px 4px;
      }
      window#waybar {
        background-color: transparent;
        padding: 1px;
        padding-bottom: 1px;
      }
      window#waybar.hidden {
        opacity: 0.2;
      }
      window#waybar.empty #window {
          background-color: transparent;
          color: transparent;
      }
      #clock,
      #memory,
      #cpu,
      #temperature,
      #pulseaudio,
      #network,
      #battery,
      #custom-launcher,
      #custom-gpu,
      #workspaces,
      #custom-powermenu {
        padding-left: 12px;
        padding-right: 12px;
      }
      #workspaces button {
        color: #${config.colorScheme.palette.base04};
      }
      #workspaces button.active {
        color: #${config.colorScheme.palette.base0F};
      }
      #custom-launcher {
        color: #${config.colorScheme.palette.base0F};
      }
      #memory {
        color: #${config.colorScheme.palette.base0E};
      }
      #cpu {
        color: #${config.colorScheme.palette.base0F};
      }
      #clock {
        color: #${config.colorScheme.palette.base0A};
      }
      #battery {
        min-width: 52px;
        color: #${config.colorScheme.palette.base0B};
      }
      #battery.charging,
      #battery.full,
      #battery.plugged {
        color: #${config.colorScheme.palette.base0B};
      }
      #battery.critical:not(.charging) {
        color: #${config.colorScheme.palette.base08};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
      #temperature {
        color: #${config.colorScheme.palette.base0F};
      }
      #custom-gpu {
        color: #${config.colorScheme.palette.base0E};
      }
      #pulseaudio {
        color: #${config.colorScheme.palette.base06};
      }
      #network {
        color: #${config.colorScheme.palette.base0B};
      }
      #network.disconnected {
        color: #${config.colorScheme.palette.base09};
      }
      #custom-powermenu {
        color: #${config.colorScheme.palette.base08};
      }
    '';
    settings = [{
      "layer" = "top";
      "position" = "top";
      modules-left = [
        "custom/launcher"
        "temperature"
        "custom/gpu"
        "cpu"
        "memory"
      ];
      modules-center = [
        "hyprland/workspaces"
      ];
      modules-right = [
        "pulseaudio"
        "battery"
        "network"
        "clock"
        "custom/powermenu"
      ];
      "custom/launcher" = {
        "format" = " ";
        "tooltip" = false;
      };
      "hyprland/workspaces" = {
        "tooltip" = false;
        "all-outputs" = true;
        "on-click" = "activate";
      };
      "pulseaudio" = {
        "scroll-step" = 1;
        "format" = "{icon}  {volume}%";
        "format-muted" = "󰖁 Muted";
        "format-icons" = {
          "default" = [ "" "" "" ];
        };
        "on-click" = "pavucontrol";
        "tooltip" = false;
      };
      "clock" = {
        "format-alt" = "{:%Y-%m-%d}";
        "tooltip-format" = "{:%Y-%m-%d | %H:%M}";
      };
      "memory" = {
        "interval" = 1;
        "format" = "󰻠 {percentage}%";
        "states" = {
          "warning" = 85;
        };
      };
      "cpu" = {
        "interval" = 1;
        "format" = "󰍛 {usage}%";
      };
      "network" = {
        "format-disconnected" = "󰯡 Disconnected";
        "format-ethernet" = "󰒢 Connected!";
        "format-linked" = "󰖪 {essid} (No IP)";
        "format-wifi" = "󰖩 {essid}";
        "interval" = 1;
        "tooltip" = false;
        "on-click" = "kitty --class nmwui nmtui";
      };
      "battery" = {
          "format" = "{icon}  {capacity}%";
          "format-icons" = ["" "" "" "" ""];
	  "interval" =  30;
          "states" = {
              "warning" = 25;
              "critical" = 10;
          };
          "tooltip" =  false;
      };
      "custom/powermenu" = {
        "format" = "";
        "on-click" = "bash ~/.config/rofi/power.sh";
        "tooltip" = false;
      };
     "temperature" = {
       "critical-threshold" = 90;
       "on-click" = "kitty --class center-float-large btop";
       "hwmon-path" = "/sys/class/hwmon/hwmon1/temp1_input";
       "format-critical" = "{icon} {temperatureC}°C";
       "format" = "{icon} {temperatureC}°C";
       "format-icons" =  ["" "" ""];
       "tooltip" = true;
       "interval" = 3;
      };
      "custom/gpu" = {
         "exec" = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader";
         "critical-threshold" = 90;
         "format" = "{icon} {}°C";
         "format-icons" =  ["" "" ""];
         "interval" = 3;
      };

    }];
  };
}
