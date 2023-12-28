{ ... }: {

  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    style = ''
      * {
        border: none;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13pt;
        min-height: 25px;
      }
      window#waybar {
        background: transparent;
      }
      #clock,
      #memory,
      #temperature,
      #cpu,
      #temperature,
      #pulseaudio,
      #network,
      #battery,
      #custom-launcher,
      #workspaces,
      #custom-powermenu {
        background-color: #11111b;
        border-radius: 8px;
        color: #cdd6f4;
        margin-top: 5px;
        margin-right: 5px;
        margin-left: 5px;
        padding-left: 10px;
        padding-right: 10px;
      }
      #workspaces button {
        padding-top: 5px;
        padding-bottom: 5px;
        padding-left: 6px;
        padding-right: 6px;
      }
      #workspaces button.active {
        background-color: #45475a;
        color: rgb(26, 24, 38);
      }
      #workspaces button.urgent {
        color: rgb(26, 24, 38);
      }
      #workspaces button:hover {
        background-color: #313244;
        color: rgb(26, 24, 38);
      }
      #custom-launcher {
        color: #7ebae4;
      }
      #memory {
        color: rgb(181, 232, 224);
      }
      #cpu {
        color: rgb(245, 194, 231);
      }
      #clock {
        color: rgb(217, 224, 238);
      }
      
      #battery {
        min-width: 55px;
        color: rgb(126, 186, 244);
      }
      #battery.charging,
      #battery.full,
      #battery.plugged {
        color: #26a65b;
      }
      #battery.critical:not(.charging) {
        color: #f53c3c;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
      #temperature {
        color: rgb(150, 205, 251);
      }
      #pulseaudio {
        color: rgb(245, 224, 220);
      }
      #network {
        color: #abe9b3;
      }
      #network.disconnected {
        color: rgb(255, 255, 255);
      }
      #custom-powermenu {
        color: rgb(242, 143, 173);
      }
    '';
    settings = [{
      "layer" = "top";
      "position" = "top";
      modules-left = [
        "custom/launcher"
        "temperature"
        "clock"
      ];
      modules-center = [
        "hyprland/workspaces"
      ];
      modules-right = [
        "pulseaudio"
        "battery"
        "memory"
        "network"
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
        "format" = "{icon} {volume}%";
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
          "format" = "{capacity}% {icon}";
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
        "on-click" = "bash ~/.config/wofi/power.sh";
        "tooltip" = false;
      };
    }];
  };
}
