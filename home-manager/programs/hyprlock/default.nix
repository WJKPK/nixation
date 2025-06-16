{ config, ...}: let
  wallpaper = builtins.fetchurl {
      url = "https://images4.alphacoders.com/130/1301526.png";
      sha256 = "0m2ilvs8rbyfw999lf7540cdx993mqq2rqw79z4dq22bfm0mnjfc";
  };
in {
  imports = [
    ./hypridle.nix
  ];
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          monitor = "";
          path = "${wallpaper}";
          blur_passes = 4; # 0 disables blurring
          blur_size = 2;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];
      input-field = [
        {
            monitor = "";
            size = "350, 50";
            outline_thickness = 3;
            dots_size = 0.1;
            dots_spacing = 0.5;
            outer_color = "rgb(${config.colorScheme.palette.base0F})";
            inner_color = "rgb(${config.colorScheme.palette.base00})";
            font_color = "rgb(${config.colorScheme.palette.base05})";
            fade_on_empty = true;
            position = "0, -80";
            halign = "center";
            valign = "center";
            rounding = 0;
        }
      ];
      label = [
          {
            monitor = "";
            text = "$TIME";
            color = "rgba(200, 200, 200, 1.0)";
            font_size = 120;
            font_family = "JetBrainsMono Nerd Font";
            rotate = 0.000000;
            shadow_passes = 0;
            shadow_size = 3;
            shadow_color = "rgba(0, 0, 0, 1.0)";
            shadow_boost = 1.200000;

            position = "0, 100";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = ''cmd[update:3600000] echo -e "$(date +"%a, %d %b")"'';
            color = "rgba(200, 200, 200, 1.0)";
            font_size = 20;
            font_family = "JetBrainsMono Nerd Font";
            rotate = 0.000000;
            shadow_passes = 0;
            shadow_size = 3;
            shadow_color = "rgba(0, 0, 0, 1.0)";
            shadow_boost = 1.200000;

            position = "0, 00";
            halign = "center";
            valign = "center";
          }
        ];
    };
  };
}
