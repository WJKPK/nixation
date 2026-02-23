{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.desktop.addons.idle;

  # Determine lock screen based on idle manager
  # hypridle -> hyprlock (Hyprland)
  # swayidle -> noctalia (Niri)
  isHyprlock = cfg.manager == "hypridle";

  lockCommand =
    if isHyprlock
    then "${config.home.profileDirectory}/bin/hyprlock"
    else let
    in "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia-shell ipc call lockScreen lock";

  displayOffCommand =
    if isHyprlock
    then "hyprctl dispatch dpms off"
    else "niri msg action power-off-monitors";

  displayOnCommand =
    if isHyprlock
    then "hyprctl dispatch dpms on"
    else "niri msg action power-on-monitors";

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
  options.desktop.addons.idle = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = "Enable idle management.";
    };

    manager = mkOption {
      type = enum ["none" "hypridle" "swayidle"];
      default = "none";
      description = "Idle manager to use. hypridle uses hyprlock (Hyprland), swayidle uses noctalia (Niri).";
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

  imports = [
    ./hypridle.nix
    ./swayidle.nix
  ];

  config = mkIf cfg.enable {
    # Ensure hyprlock is enabled when using hypridle
    desktop.addons.hyprlock.enable = mkIf isHyprlock true;

    # Make commands available to child modules
    _module.args = {
      inherit lockCommand displayOffCommand displayOnCommand suspendCommand;
    };
  };
}
