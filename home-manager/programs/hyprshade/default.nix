{pkgs, ...}:
{
  home.packages = with pkgs; [
    hyprshade
  ];

  xdg.configFile."hyprshade/config.toml".text = ''
    [[shades]]
    name = "vibrance"
    default = true  # shader to use during times when there is no other shader scheduled
    
    [[shades]]
    name = "blue-light-filter"
    start_time = 19:00:00
    end_time = 06:00:00   # optional if you have more than one shade with start_time
  '';

  systemd.user.services.hyprshade = {
    Unit = {
      Description = "Run hyprshade";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.hyprshade}/bin/hyprshade";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers.hyprshade = {
    Unit = {
      Description = "Run hyprshade periodically";
    };
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "10min";
      AccuracySec = "1s";
      Unit = "hyprshade.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}

