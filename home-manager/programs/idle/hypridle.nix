{
  config,
  lib,
  lockCommand,
  displayOffCommand,
  displayOnCommand,
  suspendCommand,
  ...
}:
with lib; let
  cfg = config.desktop.addons.idle;
in {
  config = mkIf (cfg.enable && cfg.manager == "hypridle") {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = lockCommand;
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = displayOnCommand;
          inhibit_sleep = 3;
        };
        listener = [
          {
            timeout = cfg.timeouts.displayOff;
            on-timeout = displayOffCommand;
            on-resume = displayOnCommand;
          }
          {
            timeout = cfg.timeouts.suspend;
            on-timeout = suspendCommand;
          }
        ];
      };
    };
  };
}
