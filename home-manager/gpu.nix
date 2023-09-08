{ lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  options.gpus = mkOption {
    type = types.listOf (types.submodule {
      options = {
        nvidia = {
            enable = mkOption {
              type = types.bool;
              default = false;
            };
            prime = mkOption {
              type = types.bool;
              default = false;
            };
        };
        amd = {
          enable = mkOption {
            type = types.bool;
            default = false;
          };
        };
      };
    });
    default = [ ];
  };
}
