{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.desktop.addons.idle;

  # Determine lock command based on lock screen choice
  lockCommand =
    if cfg.lockScreen == "hyprlock"
    then "${config.home.profileDirectory}/bin/hyprlock"
    else let
      noctalia = inputs.noctalia.packages.${pkgs.system}.default;
      noctaliaIPC = "${noctalia}/bin/noctalia-shell ipc call";
    in "${noctaliaIPC} lockScreen lock";

  # Determine display power commands based on lock screen choice
  # hyprlock = Hyprland, noctalia = Niri
  displayOffCommand =
    if cfg.lockScreen == "hyprlock"
    then "hyprctl dispatch dpms off"
    else "niri msg action power-off-monitors";

  displayOnCommand =
    if cfg.lockScreen == "hyprlock"
    then "hyprctl dispatch dpms on"
    else "niri msg action power-on-monitors";

  # Suspend script that skips suspend if VMs are running
  suspendScript = pkgs.writeShellScript "suspend-script" ''
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
      description = "Idle manager to use.";
    };

    lockScreen = mkOption {
      type = enum ["hyprlock" "noctalia"];
      default = "hyprlock";
      description = "Lock screen implementation. hyprlock assumes Hyprland, noctalia assumes Niri.";
    };

    timeouts = {
      displayOff = mkOption {
        type = int;
        default = 300;
        description = "Seconds before turning off display.";
      };

      suspend = mkOption {
        type = int;
        default = 330;
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
    # Ensure hyprlock is enabled when using hyprlock lock screen
    desktop.addons.hyprlock.enable = mkIf (cfg.lockScreen == "hyprlock") true;

    # Make commands available to child modules
    _module.args = {
      inherit lockCommand displayOffCommand displayOnCommand suspendCommand;
    };
  };
}
