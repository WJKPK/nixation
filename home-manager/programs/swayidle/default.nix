{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.desktop.addons.swayidle;
  lockCommand = "${config.programs.noctalia-shell.package}/bin/noctalia-shell ipc call lockScreen lock";
  displayOffCommand = "niri msg action power-off-monitors";
  displayOnCommand = "niri msg action power-on-monitors";
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    if ${pkgs.systemd}/bin/busctl call org.freedesktop.login1 \
         /org/freedesktop/login1 \
         org.freedesktop.login1.Manager \
         ListInhibitors \
       | grep '"idle"' \
       | grep '"sleep infinity"' >/dev/null; then
      exit 0
    fi

    ${pkgs.procps}/bin/pgrep qemu || ${pkgs.systemd}/bin/systemctl suspend
  '';

  # Actual suspend command based on VM check setting
  suspendCommand =
    if cfg.skipSuspendOnVM
    then suspendScript.outPath
    else "${pkgs.systemd}/bin/systemctl suspend";
in {
  options.desktop.addons.swayidle = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = "Enable idle management.";
    };

    timeouts = {
      lock = mkOption {
        type = int;
        default = 360;
        description = "Seconds before locking screen (only used with swayidle/noctalia).";
      };

      displayOff = mkOption {
        type = int;
        default = 400;
        description = "Seconds before turning off display.";
      };

      suspend = mkOption {
        type = int;
        default = 430;
        description = "Seconds before system suspend.";
      };
    };

    skipSuspendOnVM = mkOption {
      type = bool;
      default = true;
      description = "Skip suspend when QEMU VMs are running.";
    };
  };
  config = mkIf (cfg.enable) {
    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = cfg.timeouts.lock;
          command = lockCommand;
        }
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
        before-sleep = lockCommand;
        after-resume = displayOnCommand;
      };
    };
  };
}
