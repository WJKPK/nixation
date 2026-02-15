{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.rod.services.adguard;
in {
  options.rod.services.adguard.enable = mkEnableOption "Enable AdGuard Home";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [80 443 3002];
    networking.firewall.allowedUDPPorts = [53];

    services.adguardhome = {
      enable = true;
      mutableSettings = false;
      port = 3002;
      settings = {
        http.address = "0.0.0.0:3002";
        schema_version = 20;
        dns = {
          ratelimit = 0;
          bind_hosts = ["0.0.0.0"];
          bootstrap_dns = [
            "9.9.9.10"
            "149.112.112.10"
            "2620:fe::10"
            "2620:fe::fe:10"
          ];
          upstream_dns = [
            "1.1.1.1"
            "1.0.0.1"
            "8.8.8.8"
            "8.8.4.4"
          ];
          dhcp.enabled = false;
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
          parental_enabled = false;
          safe_search = {enabled = false;};
        };
        filters = [
          {
            enabled = true;
            url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
          }
          {
            enabled = true;
            url = "https://big.oisd.nl";
          }
        ];
      };
    };
  };
}
