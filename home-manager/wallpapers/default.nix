{ pkgs, lib,... }:
let
    wallpaper = builtins.fetchurl {
      url = "https://images4.alphacoders.com/101/1011201.jpg";
      sha256 = "1h4mchqmjg182rk36zagpimph18iz6390p221gscbvnby7hpy5rg";
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
