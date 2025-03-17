{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.addons.waybar;
in
{
  options.desktop.addons.waybar = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable/disable waybar";
    };
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
    };

    home.file.".config/waybar/config.jsonc" = {
      source = ./config.jsonc;
      onChange = ''
        ${pkgs.busybox}/bin/pkill -SIGUSR2 waybar
      '';
    };
    home.file.".config/waybar/style.css" = {
      text = ''
        * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: JetBrainsMono Nerd Font;
          font-size: 16px;
          border-radius: 0px;
        }

        #clock,
        #custom-notification,
        #custom-launcher,
        #custom-powermenu,
        #custom-window,
        #memory,
        #disk,
        #network,
        #battery,
        #pulseaudio,
        #window,
        #temperature,
        #custom-gpu,

        #tray {
          padding: 5 15px;
          border-radius: 0px;
          background: #${config.colorScheme.palette.base00};
          color: #${config.colorScheme.palette.base07};
          margin-top: 4px;
          margin-bottom: 4px;
          margin-right: 2px;
          margin-left: 2px;
          transition: all 0.3s ease;
        }

        #window {
          background-color: transparent;
          box-shadow: none;
        }

        window#waybar {
          background-color: rgba(0, 0, 0, 0.096);
          border-radius: 0px;
        }

        window * {
          background-color: transparent;
          border-radius: 0px;
        }

        #workspaces button label {
          color: #${config.colorScheme.palette.base07};
        }

        #workspaces button.active label {
          color: #${config.colorScheme.palette.base00};
          font-weight: bolder;
        }

        #workspaces button:hover {
          box-shadow: #${config.colorScheme.palette.base07} 0 0 0 1.5px;
          background-color: #${config.colorScheme.palette.base00};
          min-width: 50px;
        }

        #workspaces {
          background-color: transparent;
          border-radius: 0px;
          padding: 5 0px;
          margin-top: 3px;
          margin-bottom: 3px;
        }

        #workspaces button {
          background-color: #${config.colorScheme.palette.base00};
          border-radius: 0px;
          margin-left: 10px;

          transition: all 0.3s ease;
        }

        #workspaces button.active {
          min-width: 50px;
          box-shadow: rgba(0, 0, 0, 0.288) 2 2 5 2px;
          background-color: #${config.colorScheme.palette.base0F};
          background-size: 400% 400%;
          transition: all 0.3s ease;
          background: linear-gradient(
            58deg,
            #${config.colorScheme.palette.base0E},
            #${config.colorScheme.palette.base0E},
            #${config.colorScheme.palette.base0E},
            #${config.colorScheme.palette.base0D},
            #${config.colorScheme.palette.base0D},
            #${config.colorScheme.palette.base0E},
            #${config.colorScheme.palette.base08}
          );
          background-size: 300% 300%;
          animation: colored-gradient 20s ease infinite;
        }

        @keyframes colored-gradient {
          0% {
            background-position: 71% 0%;
          }
          50% {
            background-position: 30% 100%;
          }
          100% {
            background-position: 71% 0%;
          }
        }

        #custom-powermenu {
          margin-right: 10px;
          padding-left: 12px;
          padding-right: 15px;
          padding-top: 3px;
        }

        #custom-gpu {
          margin-right: 10px;
          padding-left: 12px;
          padding-right: 15px;
          padding-top: 3px;
        }

        @keyframes grey-gradient {
          0% {
            background-position: 100% 50%;
          }
          100% {
            background-position: -33% 50%;
          }
        }

        #tray menu {
          background-color: #${config.colorScheme.palette.base00};
          opacity: 0.8;
        }

        #pulseaudio.muted {
          color: #${config.colorScheme.palette.base08};
          padding-right: 16px;
        }

        #custom-notification.collapsed,
        #custom-notification.waiting_done {
          min-width: 12px;
          padding-right: 17px;
        }

        #custom-notification.waiting_start,
        #custom-notification.expanded {
          background-color: transparent;
          background: linear-gradient(
            90deg,
            #${config.colorScheme.palette.base02},
            #${config.colorScheme.palette.base00},
            #${config.colorScheme.palette.base00},
            #${config.colorScheme.palette.base00},
            #${config.colorScheme.palette.base00},
            #${config.colorScheme.palette.base02}
          );
          background-size: 400% 100%;
          animation: grey-gradient 3s linear infinite;
          min-width: 500px;
          border-radius: 0px;
        }
      '';
      onChange = ''
        ${pkgs.busybox}/bin/pkill -SIGUSR2 waybar
      '';
    };
  };
}

