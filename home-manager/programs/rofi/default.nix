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
        accent:           #${config.colorScheme.palette.base0D};
        background-tb:    #${config.colorScheme.palette.base00};
        border-tb:        #${config.colorScheme.palette.base05};
        selected:         linear-gradient(to right, #${config.colorScheme.palette.base01}, #B7BDF869);
        button:           linear-gradient(#${config.colorScheme.palette.base04});
        button-selected:  linear-gradient(#B7BDF869);
        active:           linear-gradient(to right, #8BD5CAFF, #A6DA95FF);
        urgent:           #ED8796FF;
      }
     '';
   };
  };
}
