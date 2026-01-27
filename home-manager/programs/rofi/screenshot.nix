{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.desktop.addons.rofi;
  screenshot_config = builtins.path {
    path = ./screenshot_style.rasi;
  };

  save_dir = "${config.xdg.userDirs.pictures}/Screenshot";
in {
  config = mkIf cfg.enable {
    home.file = {
      ".config/rofi/screenshot.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          if [ "$1" = "--freeze" ]; then
            extra_args="--freeze"
          fi

          # variables
          filename="captura-$(date +%Y-%m-%d-%s).png"
          command="${lib.getExe pkgs.hyprshot} -o ${save_dir} -f $filename $extra_args"

          # wrap command with hyprshot off/auto
          run_with_mode() {
            ${lib.getExe pkgs.hyprshade} off
            "$@"
            ${lib.getExe pkgs.hyprshade} auto
          }

          # options to be displayed
          region="󰆞"
          output=""
          window=""
          folder=""

          selected="$(echo -e "$region\n$output\n$window\n$folder" | rofi -dmenu -theme "${screenshot_config}")"
          case $selected in
          $region)
            run_with_mode $command -m region
            ;;
          $output)
            run_with_mode $command -m output
            ;;
          $window)
            run_with_mode $command -m window
            ;;
          $folder)
            ~/.config/rofi/screenshot-selection.sh
            ;;
          esac
        '';
      };
      ".config/rofi/screenshot-selection.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          build_theme() {
            rows=$1
            cols=$2
            icon_size=$3

            echo "element{orientation:vertical;}element-text{horizontal-align:0.5;}element-icon{size:$icon_size.0000em;}listview{lines:$rows;columns:$cols;}"
          }

          rofi_cmd="rofi -dmenu -i -show-icons -theme-str $(build_theme 1 5 15) -theme ${screenshot_config}"

          choice=$(
            ls -t --escape "${save_dir}" -p | grep -v / |
              while read A; do echo -en "$A\x00icon\x1f${save_dir}/$A\n"; done |
              $rofi_cmd
          )

          screenshot="${save_dir}/$choice"

          if command -v satty &>/dev/null; then
            satty -f "$screenshot"
          else
            xdg-open "$screenshot"
          fi

        '';
      };
    };
  };
}
