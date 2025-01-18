{pkgs, config, lib, ...}: let
   #match any qemu process, suspend only if any found
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.procps}/bin/pgrep qemu || ${pkgs.systemd}/bin/systemctl suspend
  '';
  locker = lib.getExe pkgs.hyprlock;
in {
  services.swayidle = {
    enable = true;
    extraArgs = ["-d" "-w"];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock";
        command = "${locker}";
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
