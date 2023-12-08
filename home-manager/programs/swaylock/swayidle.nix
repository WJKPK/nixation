{pkgs, ...}: let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.ps}/bin/ps -aux | ${pkgs.ripgrep}/bin/rg qemu | ${pkgs.ripgrep}/bin/rg -wv rg
    # only suspend if vm's aren't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
in {
  # screen idle
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 330;
        command = suspendScript.outPath;
      }
    ];
  };
}
