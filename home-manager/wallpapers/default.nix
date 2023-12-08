{ pkgs, lib,... }:
let
    wallpaper = builtins.fetchurl {
      url = "https://www.pixground.com/wp-content/uploads/2023/09/Mount-Everest-4K-Wallpaper.jpg";
      sha256 = "0dkgxnnvjvl5apml3rir2d0p34h2n4vddwxfyl99qydpmf8xjxbm";
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
