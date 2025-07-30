{ pkgs, config, lib, ... }:
let
  wallpaper = builtins.path {
    path = ../../wallpapers/colorful-planets-small.jpg;
  };
in
{
  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      extraConfig = {
        modi = "drun,filebrowser,run,combi";
        show-icons = true;
        icon-theme = "Papirus";
        location = 0;
        font = "JetBrainsMono Nerd Font 12";
        drun-display-format = "{icon} {name}";
        display-drun = " Apps";
        display-run = " Run";
        display-filebrowser = " File";
      };
      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
        in
        {
          "*" = {
            background = mkLiteral "#${config.colorScheme.palette.base00}";
            background-alt = mkLiteral "#${config.colorScheme.palette.base06}";
            foreground = mkLiteral "#${config.colorScheme.palette.base01}";
            selected = mkLiteral "#${config.colorScheme.palette.base0A}";
            active = mkLiteral "#${config.colorScheme.palette.base0F}";
            text-selected = mkLiteral "#${config.colorScheme.palette.base00}";
            text-color = mkLiteral "#${config.colorScheme.palette.base05}";
            border-color = mkLiteral "#${config.colorScheme.palette.base05}";
            urgent = mkLiteral "#${config.colorScheme.palette.base0E}";
          };
          "window" = {
            width = mkLiteral "50%";
            transparency = "real";
            orientation = mkLiteral "vertical";
            cursor = mkLiteral "default";
            spacing = mkLiteral "0px";
            border = mkLiteral "2px";
            border-color = "@border-color";
            border-radius = mkLiteral "0px";
            background-color = mkLiteral "@background";
          };
          "mainbox" = {
            padding = mkLiteral "2px";
            enabled = true;
            orientation = mkLiteral "vertical";
            children = map mkLiteral [
              "inputbar"
              "listbox"
            ];
            background-color = mkLiteral "transparent";
          };
          "inputbar" = {
            enabled = true;
            padding = mkLiteral "5px 5px 120px 5px";
            margin = mkLiteral "5px";
            background-color = mkLiteral "transparent";
            border-radius = "0px";
            orientation = mkLiteral "horizontal";
            children = map mkLiteral [
              "entry"
              "dummy"
              "mode-switcher"
            ];
            background-image = mkLiteral ''url("${wallpaper}", width)'';
          };
          "entry" = {
            enabled = true;
            expand = false;
            width = mkLiteral "20%";
            padding = mkLiteral "5px";
            border-radius = mkLiteral "0px";
            background-color = mkLiteral "@selected";
            text-color = mkLiteral "@text-selected";
            cursor = mkLiteral "text";
            placeholder = "🖥️ Search ";
            placeholder-color = mkLiteral "inherit";
          };
          "listbox" = {
            spacing = mkLiteral "5px";
            padding = mkLiteral "5px";
            background-color = mkLiteral "transparent";
            orientation = mkLiteral "vertical";
            children = map mkLiteral [
              "message"
              "listview"
            ];
          };
          "listview" = {
            enabled = true;
            columns = 1;
            lines = 8;
            cycle = true;
            dynamic = true;
            scrollbar = false;
            layout = "vertical";
            reverse = false;
            fixed-height = false;
            fixed-columns = true;
            spacing = mkLiteral "5px";
            background-color = mkLiteral "transparent";
            border = mkLiteral "0px";
          };
          "dummy" = {
            expand = true;
            background-color = mkLiteral "transparent";
          };
          "mode-switcher" = {
            enabled = true;
            spacing = mkLiteral "5px";
            background-color = mkLiteral "transparent";
          };
          "button" = {
            width = mkLiteral "5%";
            padding = mkLiteral "6px";
            border-radius = mkLiteral "0px";
            background-color = mkLiteral "@text-selected";
            text-color = mkLiteral "@text-color";
            cursor = mkLiteral "pointer";
          };
          "button selected" = {
            background-color = mkLiteral "@selected";
            text-color = mkLiteral "@text-selected";
          };
          "scrollbar" = {
            width = mkLiteral "4px";
            border = 0;
            handle-color = mkLiteral "@border-color";
            handle-width = mkLiteral "8px";
            padding = 0;
          };
          "element" = {
            enabled = true;
            spacing = mkLiteral "5px";
            padding = mkLiteral "5px";
            border-radius = mkLiteral "0px";
            background-color = mkLiteral "transparent";
            cursor = mkLiteral "pointer";
          };
          "element normal.normal" = {
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          "element normal.urgent" = {
            background-color = mkLiteral "@urgent";
            text-color = mkLiteral "@foreground";
          };
          "element normal.active" = {
            background-color = mkLiteral "@active";
            text-color = mkLiteral "@foreground";
          };
          "element selected.normal" = {
            background-color = mkLiteral "@selected";
            text-color = mkLiteral "@text-selected";
          };
          "element selected.urgent" = {
            background-color = mkLiteral "@urgent";
            text-color = mkLiteral "@text-selected";
          };
          "element selected.active" = {
            background-color = mkLiteral "@urgent";
            text-color = mkLiteral "@text-selected";
          };
          "element alternate.normal" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
          };
          "element alternate.urgent" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
          };
          "element alternate.active" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
          };
          "element-icon" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
            size = mkLiteral "36px";
            cursor = mkLiteral "inherit";
          };
          "element-text" = {
            background-color = mkLiteral "transparent";
            font = "JetBrainsMono Nerd Font Mono 12";
            text-color = mkLiteral "inherit";
            cursor = mkLiteral "inherit";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.0";
          };
          "message" = {
            background-color = mkLiteral "transparent";
            border = mkLiteral "0px";
          };
          "textbox" = {
            padding = mkLiteral "6px";
            border-radius = mkLiteral "0px";
            background-color = mkLiteral "@background-alt";
            text-color = mkLiteral "@background";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.0";
          };
          "error-message" = {
            padding = mkLiteral "6px";
            border-radius = mkLiteral "0px";
            background-color = mkLiteral "@background-alt";
            text-color = mkLiteral "@background";
          };
        };
    };
  };
}

