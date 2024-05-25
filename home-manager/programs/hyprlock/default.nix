{config, ...}: let
  wallpaper = builtins.fetchurl {
      url = "https://images4.alphacoders.com/130/1301526.png";
      sha256 = "0m2ilvs8rbyfw999lf7540cdx993mqq2rqw79z4dq22bfm0mnjfc";
  };
in {
  imports = [
    ./swayidle.nix
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
            position = "0, 100";
            halign = "center";
            valign = "center";
        }
      ];
      label = [
          # Time
          {
            text = "cmd[update:200] date +'%r'";
            color = "rgb(${config.colorScheme.palette.base0F})";
            font_size = 30;

            halign = "center";
            valign = "center";
            position = "0, -10";
          }
          # Date
          {
            text = "cmd[update:1000] date +'%a, %x'";
            color = "rgb(${config.colorScheme.palette.base0F})";
            font_size = 20;

            halign = "center";
            valign = "center";
            position = "0, -60";
          }
        ];
    };
  };
}
