{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.hw = mkOption {
      type = types.submodule {
        options = {
          gpu_type = mkOption {
            type = types.enum [ "none" "nvidia" ];
            default = "none";
            description = "Type of GPU";
            example = "nvidia";
        };
      };
    };
  };
}
