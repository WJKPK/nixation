{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.wirelessSettings= {
    bluetooth.enable = mkEnableOption "Enable graphical environment configuration";
    subGhzAdapter.enable = mkEnableOption "Enable graphical environment configuration";
  };

  config = let cfg = config.wirelessSettings;
  in
    mkIf (cfg.subGhzAdapter.enable) {
        hardware.rtl-sdr.enable = true;
    } // mkIf (cfg.bluetooth.enable) {
        hardware.bluetooth = {
          enable = true;
          settings = {
            General = {
                Enable = "Source,Sink,Media,Socket";
              };
            };
        };
        services.blueman.enable = mkIf config.graphicalEnvironment.enable true;
    };
}
