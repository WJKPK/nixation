{ pkgs, lib,... }:
let
  wallpaper = builtins.path {
    path = ./colorful-planets.jpg;
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
