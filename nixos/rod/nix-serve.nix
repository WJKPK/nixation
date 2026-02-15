{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.rod.services.nixServe;
in {
  options.rod.services.nixServe.enable = mkEnableOption "Expose nix-serve cache";

  config = mkIf cfg.enable {
    services.nix-serve = {
      enable = true;
      secretKeyFile = "/home/kruppenfield/nix-serve/cache-priv-key.pem";
      package = pkgs.nix-serve-ng;
      port = 5050;
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts.cache.locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
    };

    networking.firewall.allowedTCPPorts = [config.services.nginx.defaultHTTPListenPort];
  };
}
