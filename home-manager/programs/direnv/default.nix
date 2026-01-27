{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.utilities.direnv;
in {
  options.utilities.direnv = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable direnv.";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
