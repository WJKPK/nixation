{ lib, ... }:
let inherit (lib) mkOption types;
in {
  options = {
    minimalTerminal = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable a minimal terminal configuration.";
      };
    };
  };
}

