{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.rod.services.syncthing;
in {
  options.rod.services.syncthing.enable = mkEnableOption "Enable Syncthing service";

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = "kruppenfield";
      configDir = "/home/kruppenfield/.config/syncthing";
      overrideDevices = false;
      overrideFolders = false;
      guiAddress = "0.0.0.0:8384";
    };
    networking.firewall.allowedTCPPorts = [8384 22000];
    networking.firewall.allowedUDPPorts = [22000 21027];
  };
}
