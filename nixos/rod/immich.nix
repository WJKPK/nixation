{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.rod.services.immich;
in {
  options.rod.services.immich.enable = mkEnableOption "Enable Immich photo service";

  config = mkIf cfg.enable {
    services.immich = {
      enable = true;
      port = 2283;
      database.enable = true;
      redis.enable = true;
      machine-learning.enable = true;
      machine-learning.environment = {};
      host = "0.0.0.0";
    };
    users.users.immich.extraGroups = ["video" "render"];
    networking.firewall.allowedTCPPorts = [2283];
  };
}
