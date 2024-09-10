{ pkgs, config, lib, ... }: 
let
  getAvgMonitorSize = monitorsList:
    let
      maxWidth = lib.foldl' (m: acc: acc.width + m.width) {width = 0;} monitorsList;
      maxHeight = lib.foldl' (m: acc: acc.height + m.height) {height = 0;} monitorsList;
      numMonitors = lib.length monitorsList;
    in
    {
      width = maxWidth / numMonitors / 2;
      height = maxHeight / numMonitors / 2;
    };
  avg_monitor_size = getAvgMonitorSize config.monitors;
in
{
  rofi_settings = {
    launcher_width = avg_monitor_size.width;
    launcher_height = avg_monitor_size.height;
  };

  imports = [
    ./launcher.nix
    ./power.nix
    ./screenshot.nix
  ];

  home.packages = with pkgs; [
    rofi-wayland
  ];

  home.file = {
   ".local/share/rofi/themes/theme.rasi" = {
     text = ''
       * {
        background:       #${config.colorScheme.palette.base00};
        foreground:       #${config.colorScheme.palette.base0F};
        accent:           #${config.colorScheme.palette.base0E};
        background-tb:    #${config.colorScheme.palette.base02};
        border-tb:        #${config.colorScheme.palette.base05};
        selected:         #${config.colorScheme.palette.base01};
        button:           #${config.colorScheme.palette.base0D};
        button-selected:  #${config.colorScheme.palette.base07};
        active:           #${config.colorScheme.palette.base0B};
        urgent:           #${config.colorScheme.palette.base08};
      }
     '';
   };
  };
}
