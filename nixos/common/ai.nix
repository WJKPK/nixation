{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  aiServices = {
    services = {
      ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
        acceleration = "cuda";
        environmentVariables = {
          OLLAMA_FLASH_ATTENTION = "1";
          OLLAMA_CONTEXT_LENGTH = "16384";
        };
      };
      open-webui = {
        enable = true;
        port = 8085;
        package = pkgs.stable.open-webui;
      };
    };
  };
in
{
  options.aiLocal = {
    enable = mkEnableOption "Enable AI services";
  };
  config = let cfg = config.aiLocal; in (mkIf cfg.enable aiServices);
}
