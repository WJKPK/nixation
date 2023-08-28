{ pkgs, ...}:
let
    wallpaper = builtins.fetchurl {
      url = "https://r4.wallpaperflare.com/wallpaper/161/748/966/cloud-veil-covering-the-green-mountains-green-leafed-trees-wallpaper-9b561cdd83113f494534fb491d8c8c10.jpg";
      sha256 = "0ak047zvmd601hbb9dd9m40p308l8d3avni8l6mcydp562zqdn7i";
    };
  in {

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      ignore-empty-password = true;
      disable-caps-lock-text = true;
      font = "Liga SFMono Nerd Font";
      grace = 2;

      clock = true;
      timestr = "%R";
      datestr = "%a, %e of %B";
#
      image = "${wallpaper}";
#
      fade-in = "0.2";
#
      effect-blur = "10x2";
      effect-scale = "0.1";
      indicator = true;
      indicator-radius = 140;
      indicator-thickness = 5;
      indicator-caps-lock = true;

      key-hl-color = "#8aadf4";
      bs-hl-color = "#ed8796";
      caps-lock-key-hl-color = "#f5a97f";
      caps-lock-bs-hl-color = "#ed8796";

      separator-color = "#181926";

      inside-color = "#24273a";
      inside-clear-color = "#24273a";
      inside-caps-lock-color = "#24273a";
      inside-ver-color = "#24273a";
      inside-wrong-color = "#24273a";

      ring-color = "#1e2030";
      ring-clear-color = "#8aadf4";
      ring-caps-lock-color = "231f20D9";
      ring-ver-color = "#1e2030";
      ring-wrong-color = "#ed8796";

      line-color = "#8aadf4";
      line-clear-color = "#8aadf4";
      line-caps-lock-color = "#f5a97f";
      line-ver-color = "#181926";
      line-wrong-color = "#ed8796";

      text-color = "#8aadf4";
      text-clear-color = "#24273a";
      text-caps-lock-color = "#f5a97f";
      text-ver-color = "#24273a";
      text-wrong-color = "#24273a";
    };
  };
}

