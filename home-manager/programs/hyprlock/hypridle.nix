{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop.addons.hyprlock;
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.procps}/bin/pgrep qemu || ${pkgs.systemd}/bin/systemctl suspend
  '';
  locker = "${config.home.profileDirectory}/bin/hyprlock";
in {
  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = locker;
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          inhibit_sleep = 3;
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 330;
            on-timeout = suspendScript.outPath; # Use custom suspend script
          }
        ];
      };
    };
  };
}
