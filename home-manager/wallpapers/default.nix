{
  pkgs,
  lib,
  ...
}: let
  wallpaper = builtins.path {
    path = ./mountain.jpg;
  };
in {
  home.packages = with pkgs; [
    swaybg
  ];

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = ["hyprland-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper} -m fill";
      Restart = "on-failure";
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
}
