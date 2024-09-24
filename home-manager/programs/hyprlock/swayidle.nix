{pkgs, config, lib, ...}: let
   #match any qemu process, suspend only if any found
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.procps}/bin/pgrep qemu || ${pkgs.systemd}/bin/systemctl suspend
  '';
  lock = lib.getExe config.programs.hyprlock.package;
  lockScript = pkgs.writeShellScript "lock-script" ''
    ${pkgs.procps}/bin/pidof hyprlock || ${lock} -c ${config.xdg.configHome}/hypr/hyprlock.conf
  '';

in {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock";
        command = lockScript.outPath;
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 330;
        command = suspendScript.outPath;
      }
    ];
  };
}
