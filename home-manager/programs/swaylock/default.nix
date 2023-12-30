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
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-radius = 100;
      indicator-thickness = 10;
      indicator-idle-visible = true;
      key-hl-color = "00000066";
      separator-color = "00000000";
      
      inside-color = "00000033";
      inside-clear-color = "ffffff00";
      inside-caps-lock-color = "ffffff00";
      inside-ver-color = "ffffff00";
      inside-wrong-color = "ffffff00";
      
      ring-color = "ffffff";
      ring-clear-color = "ffffff";
      ring-caps-lock-color = "ffffff";
      ring-ver-color = "ffffff";
      ring-wrong-color = "ffffff";
      
      line-color = "00000000";
      line-clear-color = "ffffffFF";
      line-caps-lock-color = "ffffffFF";
      line-ver-color = "ffffffFF";
      line-wrong-color = "ffffffFF";
      
      text-color = "ffffff";
      text-clear-color = "ffffff";
      text-ver-color = "ffffff";
      text-wrong-color = "ffffff";
      
      bs-hl-color = "ffffff";
      caps-lock-key-hl-color = "ffffffFF";
      caps-lock-bs-hl-color = "ffffffFF";
      text-caps-lock-color = "ffffff";
    };
  };
}
