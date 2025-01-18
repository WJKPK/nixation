{ pkgs, config, ... }: 
{
  imports = [
    ./launcher.nix
    ./power.nix
    ./screenshot.nix
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
