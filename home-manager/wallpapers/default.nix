{
  pkgs,
  lib,
  default,
  ...
}:
let
    wallpaper = builtins.fetchurl {
      url = "https://r4.wallpaperflare.com/wallpaper/161/748/966/cloud-veil-covering-the-green-mountains-green-leafed-trees-wallpaper-9b561cdd83113f494534fb491d8c8c10.jpg";
      sha256 = "0ak047zvmd601hbb9dd9m40p308l8d3avni8l6mcydp562zqdn7i";
    };
  in {

  home.packages = with pkgs; [
    swaybg
  ];

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper} -m fill";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
