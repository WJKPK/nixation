{
  config,
  lib,
  displayOffCommand,
  displayOnCommand,
  suspendCommand,
  ...
}:
with lib; let
  cfg = config.desktop.addons.idle;
in {
  config = mkIf (cfg.enable && cfg.manager == "swayidle") {
    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = cfg.timeouts.displayOff;
          command = displayOffCommand;
        }
        {
          timeout = cfg.timeouts.suspend;
          command = suspendCommand;
        }
      ];
      events = {
        before-sleep = "loginctl lock-session";
        after-resume = displayOnCommand;
      };
    };
  };
}
