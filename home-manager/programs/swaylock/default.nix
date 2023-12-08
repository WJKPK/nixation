{ pkgs, ... }: 
let
  wallpaper = builtins.fetchurl {
      url = "https://r4.wallpaperflare.com/wallpaper/161/748/966/cloud-veil-covering-the-green-mountains-green-leafed-trees-wallpaper-9b561cdd83113f494534fb491d8c8c10.jpg";
      sha256 = "0ak047zvmd601hbb9dd9m40p308l8d3avni8l6mcydp562zqdn7i";
  };
in {
  imports = [
    ./swayidle.nix
  ];
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock;
    settings = {
      image = "${wallpaper}"; 

      font-size = 15;

      line-uses-inside = true;
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-radius = 40;
      indicator-idle-visible = true;
      indicator-y-position = 1000;
    };
  };
}
