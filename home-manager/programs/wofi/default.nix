{ pkgs, config, ... }: { 
  home = {
    packages = with pkgs; [
      wofi
    ];
  };

  home.file = {
    ".config/wofi/config" = {
      text = ''
        width=780
        lines=15
        location=0
        prompt=Search...
        filter_rate=100
        allow_markup=false
        no_actions=true
        halign=fill
        orientation=vertical
        content_halign=fill
        insensitive=true
        allow_images=true
        image_size=20
        hide_scroll=true
      '';
    };
    ".config/wofi/style.css" = {
      text = ''
        window {
          margin: 0px;
          background-color: #${config.colorScheme.colors.base00};
        }

        #input {
          all: unset;
          min-height: 20px;
          padding: 4px 10px;
          margin: 4px;
          border: none;
          color: #${config.colorScheme.colors.base07};
          font-weight: bold;
          background-color: #${config.colorScheme.colors.base00};
          outline: #${config.colorScheme.colors.base05};
        }

        #inner-box {
          font-weight: bold;
          border-radius: 0px;
        }

        #outer-box {
          margin: 0px;
          padding: 3px;
          border: none;
          border-radius: 10px;
          border: 2px solid #${config.colorScheme.colors.base05};
        }

        #text:selected {
          color: #${config.colorScheme.colors.base00};
          background-color: transparent;
        }

        #entry:selected {
          background-color: #${config.colorScheme.colors.base0F};
        }
      '';
    };
    ".config/wofi/power.sh" = {
      executable = true;
      text = ''
        #!/bin/sh

        entries="⏾ Suspend\n⭮ Reboot\n⏻ Shutdown"

        selected=$(echo -e $entries|wofi --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

        case $selected in
          suspend)
            exec systemctl suspend;;
          reboot)
            exec systemctl reboot;;
          shutdown)
            exec systemctl poweroff -i;;
        esac
      '';
    };
  };
}
