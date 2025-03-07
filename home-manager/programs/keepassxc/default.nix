{ pkgs, ... } : {
    home.packages = with pkgs; [
      keepassxc
    ];

    systemd.user.services.keepassxc = {
      Unit = {
        Description = "KeePassXC password manager";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
        Restart = "on-failure";
        RestartSec = 3;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

}

