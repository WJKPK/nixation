{ pkgs, lib,... }:
let
    wallpaper = builtins.fetchurl {
      url = "https://github.com/Gingeh/wallpapers/blob/main/landscapes/evening-sky.png?raw=true";
      sha256 = "01vhwfx2qsvxgcrhbyx5d0c6c0ahjp50qy147638m7zfinhk70vx";
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
