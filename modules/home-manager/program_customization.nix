{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.rofi;
in
{
  options.rofi_settings = mkOption {
      type = types.submodule {
      options = {
        launcher_width = mkOption {
          type = types.ints.unsigned;
          example = 1920;
        };
        launcher_height = mkOption {
          type = types.ints.unsigned;
          example = 1080;
        };
      };
    };
  };
}
