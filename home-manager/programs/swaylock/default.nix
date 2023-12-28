{ pkgs, ... }: 
let
  wallpaper = builtins.fetchurl {
      url = "https://images4.alphacoders.com/130/1301526.png";
      sha256 = "0m2ilvs8rbyfw999lf7540cdx993mqq2rqw79z4dq22bfm0mnjfc";
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
      layout-bg-color = 00000000;
      layout-border-color = 00000000;
      layout-text-color = "c6d0f5";
      line-clear-color = 00000000;
      line-caps-lock-color = 00000000;
      line-ver-color = 00000000;
      line-wrong-color = 00000000;
      ring-clear-color = "f2d5cf";
      ring-caps-lock-color = "ef9f76";
      ring-ver-color = "8caaee";
      ring-wrong-color = "ea999c";
      separator-color = 00000000;
      text-color = "c6d0f5";
      text-clear-color = "f2d5cf";
      text-caps-lock-color = "ef9f76";
      text-ver-color = "8caaee";
      text-wrong-color = "ea999c";

      line-color = 00000000;
      inside-clear-color = 00000000;
      inside-caps-lock-color = 00000000;
      inside-ver-color = 00000000;
      inside-wrong-color = 00000000;
      bs-hl-color = "f5e0dc";
      key-hl-color = "e48eff";
      ring-color = "b4befe";
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-radius = 40;
      indicator-idle-visible = true;
      indicator-y-position = 1000;
    };
  };
}
